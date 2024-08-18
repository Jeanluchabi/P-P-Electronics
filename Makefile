# Define the virtual environment directory
VENV_DIR = venv

# Define the name of the Flask application
FLASK_APP = app.py

# Define the requirements file
REQUIREMENTS_FILE = requirements.txt

# Target to create a virtual environment
venv:
	python3 -m venv $(VENV_DIR)

# Target to install dependencies
install: venv
	$(VENV_DIR)/bin/pip install --upgrade pip
	$(VENV_DIR)/bin/pip install -r $(REQUIREMENTS_FILE)

# Target to run the Flask application
run: install
	FLASK_APP=$(FLASK_APP) $(VENV_DIR)/bin/flask run

# Target to initialize the database
init-db: install
	FLASK_APP=$(FLASK_APP) $(VENV_DIR)/bin/flask shell -c "from models import db; db.create_all()"

# Target to activate the virtual environment
activate:
	@echo "Run 'source $(VENV_DIR)/bin/activate' to activate the virtual environment"

# Target to clean up the virtual environment
clean:
	rm -rf $(VENV_DIR)

.PHONY: venv install run init-db activate clean
