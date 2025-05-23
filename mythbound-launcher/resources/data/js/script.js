window.addEventListener("load", () => {
  const preloader = document.getElementById("preloader");
  const launcher = document.getElementById("launcher");
  setTimeout(() => {
    preloader.style.display = "none";
    launcher.style.display = "block";
  }, 1000);
});

const tabButtons = document.querySelectorAll(".tab-button");
const tabViews = document.querySelectorAll(".tab-view");
tabButtons.forEach((btn) => {
  btn.addEventListener("click", () => {
    tabButtons.forEach((b) => b.classList.remove("active"));
    tabViews.forEach((view) => view.classList.remove("active"));
    btn.classList.add("active");
    const targetTab = btn.getAttribute("data-tab");
    document.getElementById(targetTab).classList.add("active");
  });
});

const menuBtn = document.querySelector(".menu-btn");
const menuPanel = document.getElementById("menuPanel");
menuBtn.addEventListener("click", () => {
  menuPanel.style.display =
    menuPanel.style.display === "block" ? "none" : "block";
});

const wikiButtons = document.querySelectorAll(".wiki-button");
const wikiContent = document.getElementById("wikiContent");
const wikiData = {
  1: "<img src='https://opengamescommunity.com/hellgrave/img/features/ancestral_hall_craft.png' style='width:800px'> <img src='https://opengamescommunity.com/hellgrave/img/features/forge_windows1.png' style='width:480px'><br><div class='wiki__content-title-desc'> Ancestral Hall, is a place that can be reached after completing the <b>Secret Quest</b>.<br> At this place you will find some crafting tables where you can start craft ressources and materials, but also scrolls, parchments, artifacts, emblems, equipments, potions and much more.<br>Before to start you will find at the entrance two green tables, where you can start crafting the right scrolls in order to use the right tables (right click on each table to see the recipes and start Crafting , you can see each recipe for each craft ).<br> For example if you wish craft Minerals, you will need before craft Minning Scroll then use it in order to learn recipes and start crafting minerals or refined minerals.</div>",
  2: "How install wikipedia:<br>Go to your launcher folder:<br>- Enter on resources/data/js/script.js<br>- Edit the content here.",
  3: "Content for Entry 3. Lorem ipsum dolor sit amet, ...",
  4: "Content for Entry 4. Lorem ipsum dolor sit amet, ...",
  5: "Content for Entry 5. Lorem ipsum dolor sit amet, ...",
  6: "Content for Entry 6. Lorem ipsum dolor sit amet, ...",
  7: "Content for Entry 7. Lorem ipsum dolor sit amet, ...",
};
wikiButtons.forEach((button) => {
  button.addEventListener("click", () => {
    const entryKey = button.getAttribute("data-entry");
    wikiContent.innerHTML =
      wikiData[entryKey] || "No content available for this entry.";
  });
});
