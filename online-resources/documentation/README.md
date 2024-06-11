# Editing Project Documentation

## Prerequisites

Before editing the project documentation, ensure that you have Python 3 installed on your system.

## Previewing the Docs

1. Install project dependencies:
   ```
   pip install -r requirements.txt
   ```

2. Navigate to the `docs/` directory.

3. Edit the documentation files as needed.

4. Preview the changes locally by running:
   ```
   mike serve
   ```

   This command will start a local server to preview the documentation. Open your web browser and navigate to the specified URL to view the documentation.

## Publishing Changes (only project collaborator)

1. After editing and previewing your changes, you can publish them.

2. Run the following command to deploy the changes:
   ```
   mike deploy -b static-doc --alias-type redirect <new_version> latest
   ```

   Replace `<new_version>` with the version number of your updated documentation.