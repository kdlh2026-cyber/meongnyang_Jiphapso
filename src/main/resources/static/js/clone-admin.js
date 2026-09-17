document.addEventListener('DOMContentLoaded', function () {
    var boxes = document.querySelectorAll('.admin-box');

    boxes.forEach(function (box) {
        var face = box.querySelector('.admin-box-face');

        face.addEventListener('click', function (e) {
            e.stopPropagation();
            var isOpen = box.classList.contains('open');

            boxes.forEach(function (b) {
                b.classList.remove('open');
            });

            if (!isOpen) {
                box.classList.add('open');
            }
        });
    });

    document.addEventListener('click', function () {
        boxes.forEach(function (b) {
            b.classList.remove('open');
        });
    });
});
