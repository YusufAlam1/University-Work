/*
 Authors: Gureet Kharod, Yusuf Alam
 MACIDs: kharodg, alamy1
 Date: February 27th, 2025
 Description: Javascript for Canvas assignment
                Adding functionality to draw and use the canvas
                set up in the HTML and CSS files.
*/


window.addEventListener('load', function () {
    // Grabbing elements by id
    let canvas = document.getElementById('drawing-canvas');
    let ctx = canvas.getContext('2d');
    let shapeTypeSelect = document.getElementById('shape-type');
    let colorPicker = document.getElementById('color-picker');
    let sizeSlider = document.getElementById('size-slider');
    let sizeValue = document.getElementById('size-value');
    let borderWidthSlider = document.getElementById('border-width');
    let borderWidthValue = document.getElementById('border-width-value');
    let fillCheckbox = document.getElementById('fill-checkbox');
    let undoButton = document.getElementById('undo-button');
    let clearButton = document.getElementById('clear-button');

    // Setting up an array to hold all the shapes
    let shapes = [];

    // Adding event listener to the size slider
    sizeSlider.addEventListener('input', function () {
        sizeValue.textContent = sizeSlider.value + 'px';
    });

    // Adding event listener to the border width slider
    borderWidthSlider.addEventListener('input', function () {
        borderWidthValue.textContent = borderWidthSlider.value + 'px';
    });

    /**
     * Shape class to act as the base for the other shapes
     */
    class Shape {

        /**
         * Create a new shape with the following properties
         * @param {number} x
         * @param {number} y
         * @param {string} color
         * @param {number} size
         * @param {number} borderWidth
         * @param {boolean} fill
         */
        constructor(x, y, color, size, borderWidth, fill) {
            this.x = x;
            this.y = y;
            this.color = color;
            this.size = size;
            this.borderWidth = borderWidth;
            this.fill = fill;
        }

        /**
         * Draw the shape on the canvas
         * @param {CanvasRenderingContext2D} ctx
         */
        draw(ctx) {
            // To be implemented by each shape
        }
    }

    /**
     * Rectangle shape class that extends the base Shape
     */
    class Rectangle extends Shape {
        draw(ctx) {
            // Setting variables
            ctx.strokeStyle = this.color;
            ctx.fillStyle = this.color;
            ctx.lineWidth = this.borderWidth;

            // If statement to check if the shape should be filled
            if (this.fill) {
                ctx.fillRect(this.x - this.size / 2, this.y - this.size / 2, this.size, this.size);
            }

            // If statement to check if we should draw the border
            if (this.borderWidth > 0) {
                ctx.strokeRect(this.x - this.size / 2, this.y - this.size / 2, this.size, this.size);
            }
        }

        /**
         * Convert the rectangle to a JSON object
         * @returns {Object}
         */
        toJSON() {
            return {
                type: 'rectangle',
                x: this.x,
                y: this.y,
                color: this.color,
                size: this.size,
                borderWidth: this.borderWidth,
                fill: this.fill
            };
        }
    }

    /**
     * Circle shape class that extends the base Shape
     */
    class Circle extends Shape {
        draw(ctx) {
            // Setting variables
            ctx.strokeStyle = this.color;
            ctx.fillStyle = this.color;
            ctx.lineWidth = this.borderWidth;

            // Drawing the circle path
            ctx.beginPath();
            ctx.arc(this.x, this.y, this.size / 2, 0, Math.PI * 2);
            ctx.closePath();

            // If statement to check if the shape should be filled
            if (this.fill) {
                ctx.fill();
            }

            // If statement to check if we should draw the border
            if (this.borderWidth > 0) {
                ctx.stroke();
            }
        }

        /**
         * Convert the circle to a JSON object
         * @returns {Object}
         */
        toJSON() {
            return {
                type: 'circle',
                x: this.x,
                y: this.y,
                color: this.color,
                size: this.size,
                borderWidth: this.borderWidth,
                fill: this.fill
            };
        }
    }

    /**
     * Triangle shape class that extends the base Shape
     */
    class Triangle extends Shape {
        draw(ctx) {
            // Setting variables
            ctx.strokeStyle = this.color;
            ctx.fillStyle = this.color;
            ctx.lineWidth = this.borderWidth;

            // Calculate triangle height
            let height = this.size * 0.866; // Approximate sqrt(3)/2

            // Drawing the triangle path
            ctx.beginPath();
            ctx.moveTo(this.x, this.y - height / 2);
            ctx.lineTo(this.x - this.size / 2, this.y + height / 2);
            ctx.lineTo(this.x + this.size / 2, this.y + height / 2);
            ctx.closePath();

            // If statement to check if the shape should be filled
            if (this.fill) {
                ctx.fill();
            }

            // If statement to check if we should draw the border
            if (this.borderWidth > 0) {
                ctx.stroke();
            }
        }

        /**
         * Convert the triangle to a JSON object
         * @returns {Object}
         */
        toJSON() {
            return {
                type: 'triangle',
                x: this.x,
                y: this.y,
                color: this.color,
                size: this.size,
                borderWidth: this.borderWidth,
                fill: this.fill
            };
        }
    }

    /**
     * This function creates a shape based on the user settings
     * @param {number} x
     * @param {number} y
     * @returns {Shape}
     */
    function createShape(x, y) {
        // Setting variables from user inputs
        let shapeType = shapeTypeSelect.value;
        let color = colorPicker.value;
        let size = parseInt(sizeSlider.value);
        let borderWidth = parseInt(borderWidthSlider.value);
        let fill = fillCheckbox.checked;

        // Initialize variable
        let shape;

        // If Else statement to find out which shape to create
        if (shapeType === 'rectangle') {
            shape = new Rectangle(x, y, color, size, borderWidth, fill);
        }
        else if (shapeType === 'circle') {
            shape = new Circle(x, y, color, size, borderWidth, fill);
        }
        else if (shapeType === 'triangle') {
            shape = new Triangle(x, y, color, size, borderWidth, fill);
        }

        return shape;
    }

    /**
     * A simple function to add a shape to the canvas
     * @param {number} x 
     * @param {number} y 
     */
    function addShape(x, y) {
        var shape = createShape(x, y);
        shapes.push(shape);
        redrawCanvas();
        saveToLocalStorage();
    }

    /**
     * A simple function to redraw all the shapes on to the canvas
     */
    function redrawCanvas() {
        // Clear the canvas
        ctx.clearRect(0, 0, canvas.width, canvas.height);

        // For loop to draw all the shapes
        for (var i = 0; i < shapes.length; i++) {
            shapes[i].draw(ctx);
        }
    }

    /**
     * Function to save shapes to local storage
     */
    function saveToLocalStorage() {
        localStorage.setItem('shapes', JSON.stringify(shapes));
    }

    /**
     * This function loads saved shapes from local
     * storage and reconstructs the Shape objects
     * onto the canvas.
     */
    function loadFromLocalStorage() {
        let savedShapes = localStorage.getItem('shapes');

        // If statement to check if there are any shapes in local storage
        if (savedShapes) {
            // Try Catch statement to prevent any errors from affecting the state of the program
            try {
                let shapesData = JSON.parse(savedShapes);
                shapes = [];

                // Loop through all saved shapes and recreate them
                for (let i = 0; i < shapesData.length; i++) {
                    let data = shapesData[i];
                    let shape;

                    // If Else statement to find out which shape to create
                    if (data.type === 'rectangle') {
                        shape = new Rectangle(data.x, data.y, data.color, data.size, data.borderWidth, data.fill);
                    }
                    else if (data.type === 'circle') {
                        shape = new Circle(data.x, data.y, data.color, data.size, data.borderWidth, data.fill);
                    }
                    else if (data.type === 'triangle') {
                        shape = new Triangle(data.x, data.y, data.color, data.size, data.borderWidth, data.fill);
                    }

                    // If statement to check if the shape was actually created
                    if (shape) {
                        // Adding the shape to the array
                        shapes.push(shape);
                    }
                }
            } catch (e) {
                // Worst case scenario, no previous shapes will be loaded.
                shapes = [];
            }
        }
    }

    // Load shapes from local storage when the page loads
    loadFromLocalStorage();

    // Redraw the canvas with the loaded shapes
    redrawCanvas();

    // Add event listener for canvas clicks
    canvas.addEventListener('click', function (e) {
        let rect = canvas.getBoundingClientRect();
        let x = e.clientX - rect.left;
        let y = e.clientY - rect.top;

        addShape(x, y);
    });

    // Add event listener for the Undo button
    undoButton.addEventListener('click', function () {
        if (shapes.length > 0) {
            shapes.pop();
            redrawCanvas();
            saveToLocalStorage();
        }
    });

    // Add event listener for the Clear button
    clearButton.addEventListener('click', function () {
        shapes = [];
        redrawCanvas();
        saveToLocalStorage();
    });
});
