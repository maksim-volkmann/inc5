function applyFilter(filterType) {
	const images = document.querySelectorAll('.gallery img');
	
	images.forEach(img => {
		switch (filterType) {
			case 'blur':
				img.style.filter = 'blur(5px)';
				break;
			case 'grayscale':
				img.style.filter = 'grayscale(100%)';
				break;
			case 'brightness':
				img.style.filter = 'brightness(150%)';
				break;
			case 'contrast':
				img.style.filter = 'contrast(200%)';
				break;
		}
	});
}

function resetFilters() {
	const images = document.querySelectorAll('.gallery img');
	
	images.forEach(img => {
		img.style.filter = 'none';
	});
}
