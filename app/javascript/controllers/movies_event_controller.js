import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets =["movieInput", "cardTemplate", "cardContainer", "selectMovieInput"]

  static values = {
    url: String,
  }

  connect() {
    console.log("connected");
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
        method: 'get',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      })
      .then(response => {
        if (!response.ok) {
          throw new Error(`Erreur API : ${response.statusText}`);
        }
        return response.json();
      })
      .then((data) => {
        const results = data.response.results;

        this.cardContainerTarget.innerHTML = ""
        if (results.length === 0) {
          this.cardContainerTarget.appendChild("")
        } else
        results.slice(0, 6).forEach((result) => {

          const clone = this.cardTemplateTarget.content.cloneNode(true);
          const card = clone.querySelector("div")
          const img = clone.getElementById("img");

          card.dataset.title = result.title
          card.dataset.posterUrl = result.poster_path
          card.dataset.synopsis = result.overview
          card.dataset.tomdbId = result.id

          img.src = `https://image.tmdb.org/t/p/original/${result.poster_path}`;
          img.setAttribute("data-action","click->movies-event#choiceMovie");
          img.setAttribute("data-id", result.id);
          img.setAttribute("data-title", result.title)
          img.setAttribute("data-poster-url", result.poster_path)
          img.setAttribute("data-synopsis", result.overview)
          img.classList.add("rounded")

          this.cardContainerTarget.appendChild(clone);
        });
      })
      .catch(error => console.error("Erreur lors de la recherche :", error));
    // }, 300); // 300 ms de délai
  }

  choiceMovie(event) {
    const movie = event.currentTarget
    const movieTitle = movie.dataset.title || ""
    const moviePoster = movie.dataset.posterUrl || ""
    const movieSynopsis = movie.dataset.synopsis || ""
    const input = document.getElementById("selected-movie-input")
    console.log("Movie title:", movieTitle);
    console.log("Movie poster:", moviePoster);
    console.log("Movie synopsis:", movieSynopsis);



    movie.classList.add("outline", "outline-yellow-400", "rounded")
    input.value += `${movieTitle}**${movieSynopsis}**${moviePoster}#####`
  }
}
