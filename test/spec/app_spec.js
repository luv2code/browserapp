describe("test application code", function () {
	var requirejsPath = '../../vendor/r.js';
	describe("test that dependencies are installed", function () {
		it("should have the require module loaded", function () {
			expect('function').toEqual(typeof require);
		});
		it("should have the requirejs module available", function () {
			var requirejs = require(requirejsPath);
			expect('function').toEqual(typeof requirejs);
		});
	});
	describe("the test object should have the right api", function () {
		var rjs = require(requirejsPath);
		rjs.config({ baseUrl : "../src" });
		it("should have a log function", function () {
			var test = rjs('./test');
			expect('function').toEqual(typeof test.log);
		});
	});
});