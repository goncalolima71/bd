document.getElementById('infoForm').addEventListener('submit', function(event) {
    var nome = document.getElementById('Nome').value;
    var contacto = document.getElementById('Contacto').value;
    var morada = document.getElementById('Morada').value;
    var cc = document.getElementById('CC').value;
    var email = document.getElementById('Email').value;
    var idade = document.getElementById('Idade').value;
    var emprego = document.getElementById('Emprego').value;

    if (contacto.length != 9) {
        alert('Insere um contacto válido');
        event.preventDefault(); // prevent form from submitting
    }

    if (cc.length != 9) {
        alert('Insere um cc válido');
        event.preventDefault(); // prevent form from submitting
    }

    var emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern.test(email)) {
        alert('Insere um email válido');
        event.preventDefault(); // prevent form from submitting
    }

    function previewProfilePic(event) {
        const input = event.target;
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const preview = document.getElementById('profile-pic-preview');
                preview.src = e.target.result;
                preview.style.display = 'block';
            };
            reader.readAsDataURL(input.files[0]);
        }
    }
    
});
