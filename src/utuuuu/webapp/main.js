// LOGIN PAGE: Student/Admin toggle
document.addEventListener("DOMContentLoaded", () => {
    const studentForm = document.getElementById("student-form");
    const adminForm = document.getElementById("admin-form");
    const studentToggle = document.getElementById("student-toggle");
    const adminToggle = document.getElementById("admin-toggle");

    // If elements not on this page (e.g., on dashboard), just skip
    if (!studentForm || !adminForm || !studentToggle || !adminToggle) return;

    function setMode(mode) {
        if (mode === "student") {
            studentForm.classList.add("active");
            adminForm.classList.remove("active");
            studentToggle.classList.add("active-pill");
            adminToggle.classList.remove("active-pill");
        } else {
            adminForm.classList.add("active");
            studentForm.classList.remove("active");
            adminToggle.classList.add("active-pill");
            studentToggle.classList.remove("active-pill");
        }
    }

    studentToggle.addEventListener("click", () => setMode("student"));
    adminToggle.addEventListener("click", () => setMode("admin"));

    // Default view: student login
    setMode("student");
});

// LOGIN PAGE: simple slider for left image panel
document.addEventListener("DOMContentLoaded", () => {
    const slides = document.querySelectorAll(".login2-slide");
    const dots = document.querySelectorAll(".login2-dot");
    if (!slides.length || !dots.length) return;

    let current = 0;

    function showSlide(index) {
        slides[current].classList.remove("active");
        dots[current].classList.remove("active");
        current = index;
        slides[current].classList.add("active");
        dots[current].classList.add("active");
    }

    dots.forEach((dot, idx) => {
        dot.addEventListener("click", () => showSlide(idx));
    });

    setInterval(() => {
        const next = (current + 1) % slides.length;
        showSlide(next);
    }, 7000); // change every 7 seconds
});
