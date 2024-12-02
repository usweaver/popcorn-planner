import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="user-search"
export default class extends Controller {
  static targets = [
    "searchInput",
    "usersCards",
    "userCardTemplate",
    "membersInput",
    "membersCart",
    "memberCartTemplate",
  ];

  static values = {
    url: String,
  };

  connect() {
    console.log("Hello from user_search controller");
    this.timeout = null;
  }

  search() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      const query = this.searchInputTarget.value;
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
          this.usersCardsTarget.innerHTML = "";
          const users = data.response;
          if (users.length === 0) {
            const p = document.createElement("p");
            p.innerText = "Pas de résultats";
            p.classList.add("text-center", "font-bold");
            this.usersCardsTarget.appendChild(p);
          } else {
            users.slice(0, 6).forEach((user) => {
              const clone = this.userCardTemplateTarget.content.cloneNode(true);
              const icon = clone.querySelector("i");
              const card = clone.querySelector("div");
              card.dataset.user_id = user.id;
              const full_name = user.first_name + " " + user.last_name;
              const img = clone.getElementById("img");
              img.src = user.url;
              img.alt = full_name;
              const h3 = clone.getElementById("full-name");
              h3.innerText = full_name;
              const p = clone.getElementById("username");
              p.innerText = user.username;

              const cartMembers = this.membersInputTarget.value.split("###");
              if (cartMembers.includes(user.id.toString())) {
                card.classList.remove("outline-transparent");
                card.classList.add("outline-yellow-400");
                icon.classList = "";
                icon.classList.add(
                  "fa-regular",
                  "fa-circle-check",
                  "mr-2",
                  "text-yellow-400"
                );
              }

              this.usersCardsTarget.appendChild(clone);
            });
          }
        });
    }, 300);
  }

  selectUser(event) {
    const user = event.currentTarget;
    const username = user.querySelector("#username").innerText;
    const img_url = user.querySelector("img").src;
    const user_id = user.dataset.user_id;
    const icon = user.querySelector("i");

    if (!this.membersInputTarget.value.split("###").includes(user_id)) {
      this.membersInputTarget.value += `${user_id}###`;
      const clone = this.memberCartTemplateTarget.content.cloneNode(true);
      const card = clone.querySelector("div");
      card.dataset.user_id = user_id;
      const img = clone.getElementById("img");
      img.src = img_url;
      const p = clone.getElementById("username");
      p.innerText = username;
      this.membersCartTarget.appendChild(clone);
    }

    user.classList.remove("outline-transparent");
    user.classList.add("outline-yellow-400");
    icon.classList = "";
    icon.classList.add(
      "fa-regular",
      "fa-circle-check",
      "mr-2",
      "text-yellow-400"
    );
  }

  unselectUser(event) {
    const user = event.currentTarget.closest("div");
    const user_id = user.dataset.user_id;

    const users = this.membersInputTarget.value.split("###");
    const new_users = users.filter((user) => user !== user_id);
    this.membersInputTarget.value = new_users.join("###");

    const card = this.usersCardsTarget.querySelector(
      `[data-user_id="${user_id}"]`
    );
    if (card !== null) {
      card.classList.remove("outline-yellow-400");
      card.classList.add("outline-transparent");
      const icon = card.querySelector("i");
      icon.classList = "";
      icon.classList.add("fa-solid", "fa-plus", "mr-2", "text-zinc-400");
    }
    user.remove();
  }
}
