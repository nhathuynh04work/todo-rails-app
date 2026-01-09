import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	connect() {
		setTimeout(() => {
			this.element.classList.remove("translate-y-full", "opacity-0");
			this.element.classList.add("translate-y-0", "opacity-100");
		}, 100);

		setTimeout(() => {
			this.dismiss();
		}, 4000);
	}

	dismiss() {
		this.element.classList.remove("translate-y-0", "opacity-100");
		this.element.classList.add("translate-y-full", "opacity-0");

		setTimeout(() => {
			this.element.remove();
		}, 500);
	}
}
