import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "movieInput",
    "cardTemplate",
    "cardContainer",
    "selectMovieInput",
    "imgCard",
    "selectedCardContainer",
    "selectedCard",
    "moviesInfosInput",
    "panier"
  ];

  static values = {
    url: String,
  };

  connect() {
    console.log("connected");
    this.selectedMovies = []
    this.divCardContainer = document.getElementById("divCardContainer")

    if (this.selectedMovies.length === 0) {
      divCardContainer.innerHTML = '<p class="text"> Aucun film sélectionné </p>'
    }
  }

  search(event) {
    event.preventDefault();
    // Annule le timeout précédent si une nouvelle recherche est initiée
    clearTimeout(this.timeout);

    // Définit un délai de 300ms avant d'exécuter la requête
    // this.timeout = setTimeout(() => {
    const query = this.movieInputTarget.value;
    const url = `${this.urlValue}?query=${query}`;

    fetch(url, {
      method: "get",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
      },
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error(`Erreur API : ${response.statusText}`);
        }
        return response.json();
      })
      .then((data) => {
        const results = data.response.results;

        this.cardContainerTarget.innerHTML = "";
        if (results.length === 0) {
          this.cardContainerTarget.appendChild("");
        } else
          results.slice(0, 6).forEach((result) => {
            const clone = this.cardTemplateTarget.content.cloneNode(true);
            const card = clone.querySelector("div");
            const img = clone.getElementById("img");

            card.dataset.title = result.title;
            card.dataset.posterUrl = result.poster_path;
            card.dataset.synopsis = result.overview;
            card.dataset.tmdbId = result.id;

            img.src = `https://image.tmdb.org/t/p/original/${result.poster_path}`;
            img.setAttribute("data-action", "click->movies-event#choiceMovie");
            img.setAttribute("data-movies-event-target", "imgCard")
            img.setAttribute("data-id", result.id);
            img.setAttribute("data-title", result.title);
            img.setAttribute("data-poster-url", result.poster_path);
            img.setAttribute("data-synopsis", result.overview);
            img.classList.add("rounded");

            this.cardContainerTarget.appendChild(clone);
          });
      })
      .catch((error) => console.error("Erreur lors de la recherche :", error));
    // }, 300); // 300 ms de délai
  }

  choiceMovie(event) {
    const movie = event.currentTarget

    const movieTitle = movie.dataset.title || ""
    const movieTmdbId = movie.dataset.id || ""
    const moviePoster = movie.dataset.posterUrl || ""
    const movieSynopsis = movie.dataset.synopsis || ""

    this.selectedMovies.push(
      {
        title: movieTitle,
        description: movieSynopsis,
        posterUrl: moviePoster,
        tmdbId: movieTmdbId
      }
    )

    if (this.selectedMovies.length === 1) {
      this.divCardContainer.innerText = ""
      this.divCardContainer.insertAdjacentHTML('beforeend', '<div class="grid grid-cols-6 gap-2" id="selected-card-container" data-movies-event-target="panier">');
    }

    const selectedCardContainer = document.getElementById("selected-card-container")
    const div = document.createElement("div")
    const imgCard = document.createElement("img")

    selectedCardContainer.insertAdjacentElement("beforeend",div)
    div.setAttribute("data-movies-event-target", "selectedCard")
    div.classList.add("divMark")
    div.dataset.name = movieTitle
    div.insertAdjacentElement("beforeend",imgCard)
    imgCard.src = `https://image.tmdb.org/t/p/original/${moviePoster}`
    imgCard.classList.add("rounded-lg")
    div.insertAdjacentHTML("afterbegin", '<div class="absolute flex items-center justify-center m-0.5 rounded-full w-4 h-4 bg-zinc-800"><i class="fa-solid fa-xmark shadow-lg text-xs" data-action="click->movies-event#deleteCard"></i></div>')

    movie.classList.add("outline", "outline-yellow-400")
    movie.classList.add("pointer-events-none")
    movie.closest('div').insertAdjacentHTML("afterbegin", '<div id="checkBox" class= "absolute right-2.5 bg-zinc-800 rounded-full w-3 h-3 flex items-center justify-center top-2.5"><i class="fa-solid fa-circle-check text-yellow-400 text-md"></i></div>')

    if (this.selectedMovies.length > 0) {
      divCardContainer.classList.remove("hidden")
    }

    this.getString()
  }

  deleteCard(event) {
    const img = event.currentTarget.closest(".divMark")
    const nameMovie = img.dataset.name
    const movie = document.querySelectorAll(`[data-title="${nameMovie}"]`)[1];
    const checkBox = document.getElementById("checkBox")

    checkBox.remove()
    movie.classList.remove("outline", "outline-yellow-400")
    movie.classList.remove("pointer-events-none")
    this.selectedMovies = this.selectedMovies.filter((movie) => movie.title !== nameMovie)
    img.remove()
    this.getString()

    if (this.selectedMovies.length === 0) {
      this.divCardContainer.innerHTML = '<p class="text"> Aucun film sélectionné </p>'
    }
  }

  getString() {
    let movies_infos = ""
    this.selectedMovies.forEach((movie) => {
      movies_infos += `${movie.title}**${movie.description}**${movie.posterUrl}---`
    })
    const input = document.getElementById("selected-movie-input")
    input.value = movies_infos
  }
}
