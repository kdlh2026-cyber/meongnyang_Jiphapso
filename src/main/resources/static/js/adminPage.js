document.querySelectorAll('.accordion button').forEach(btn => {
    btn.addEventListener('click', () => {
        const li = btn.parentElement;
        li.classList.toggle('open');
    });
});/**
 * 
 */