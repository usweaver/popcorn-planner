import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "movieInput",
    "cardTemplate",
    "cardContainer",
    "selectMovieInput",
    "selectedCardContainer",
    "selectedCard"
  ];

  static values = {
    url: String,
  };

  connect() {
    console.log("connected");
    this.movieIds = []
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
            card.dataset.tomdbId = result.id;

            img.src = `https://image.tmdb.org/t/p/original/${result.poster_path}`;
            img.setAttribute("data-action", "click->movies-event#choiceMovie");
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
    console.log(movie);

    const movieTitle = movie.dataset.title || ""
    const movieId = movie.dataset.id || ""
    const moviePoster = movie.dataset.posterUrl || ""
    const movieSynopsis = movie.dataset.synopsis || ""
    const input = document.getElementById("selected-movie-input")
    const selectedCardContainer = document.getElementById("selected-card-container")
    const div = document.createElement("div")
    const imgCard = document.createElement("img")

    selectedCardContainer.insertAdjacentElement("beforeend",div)
    div.setAttribute("data-movies-event-target", "selectedCard")
    div.insertAdjacentElement("beforeend",imgCard)

    imgCard.src = `https://image.tmdb.org/t/p/original/${moviePoster}`
    imgCard.classList.add("rounded-lg")
    div.insertAdjacentHTML("afterbegin", '<i class="fa-solid fa-xmark absolute" data-action="click->movies-event#deleteCard"></i>')

    movie.classList.add("outline", "outline-yellow-400")
    // this.movieIds.push(movieId)
    input.value += `${movieTitle}**${movieSynopsis}**${moviePoster}---`
  }

  deleteCard(event) {
    const img = event.currentTarget
    img.remove()
  }

  // Créer un tableau de hash, ou chaque hash represente un film
  // Lors du click vérifier si le film est dans le tableau, si il y est alors
  // on supprime le faite qu'il soit entouré en jaune,
  // on le supprime du tableau

  // Si il n'y ai pas alors je l'entoure en jaune
  // je l'ajoute dans le tableau

  // Lors de l'envoi du formulaire
  // je construit ma fameuse string à partir des éléments que j'ai dans mon tableau
}
