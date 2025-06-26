<?php
// index.php

// Ensure session is started at the very beginning of the main page.
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

// Include your database configuration.
require 'config.php';

// Redirect if user is not logged in.
if (!isset($_SESSION['username'])) {
    header("Location: login.php");
    exit();
}

$projectError = ""; // Initialize error messages
$deleteProjectError = "";

/* ---------------------------
    Project Deletion (Admin Only)
------------------------------ */
// NOTE: Deletion still remains admin-only, as per the original requirement.
if (isset($_GET['deleteProject']) && isset($_SESSION['admin']) && $_SESSION['admin'] == 1) {
    $delID = intval($_GET['deleteProject']);
    try {
        $pdo->beginTransaction();
        // Delete associated stages first
        $stmtDelStages = $pdo->prepare("DELETE FROM tblproject_stages WHERE projectID = ?");
        $stmtDelStages->execute([$delID]);
        // Then delete the project itself
        $stmtDel = $pdo->prepare("DELETE FROM tblproject WHERE projectID = ?");
        $stmtDel->execute([$delID]);
        $pdo->commit();
        // Removed header redirect on success to keep user on the page,
        // but note that the page will still refresh due to GET request.
        // A success message could be added here if desired.
        // For a seamless experience without refresh, AJAX would be required.
    } catch (PDOException $e) {
        $pdo->rollBack();
        $deleteProjectError = "Error deleting project: " . $e->getMessage();
    }
}

/* ---------------------------
    Add Project Processing
------------------------------ */
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['addProject'])) {
    $prNumber = trim($_POST['prNumber']);
    $projectDetails = trim($_POST['projectDetails']);
    // Ensure userID is set. This makes sure only logged-in users can add.
    $userID = $_SESSION['userID'] ?? null; 

    // Enhanced error handling with more specific messages and a check for '0'
    if (is_null($userID)) {
        $projectError = "You must be logged in to add a project.";
    } elseif (empty($prNumber)) {
        $projectError = "Project Number is a required field.";
    } elseif ($prNumber === '0') { // Specific check for '0', as req   uested
        $projectError = "Project Number must contain only numbers (e.g., '123')."; 
    } elseif (!preg_match('/^[\d\-]+$/', $prNumber)) { // General 'numbers only' check
        $projectError = "Project Number must contain only numbers (e.g., '123').";
    } elseif (empty($projectDetails)) { // Check for project details after all project number validations
        $projectError = "Project Details is a required field.";
    } else {
        try {
            $pdo->beginTransaction();
            $stmt = $pdo->prepare("INSERT INTO tblproject (prNumber, projectDetails, userID) VALUES (?, ?, ?)");
            $stmt->execute([$prNumber, $projectDetails, $userID]);
            $newProjectID = $pdo->lastInsertId();
            // Insert stages for the new project (set createdAt for 'Purchase Request')
            // This needs $stagesOrder array defined. Assuming it's defined elsewhere or will be defined.
            // For now, hardcode a common set of stages if $stagesOrder is not provided.
            $stagesOrder = [
                'Purchase Request' => 'PR',
                'RFQ 1' => 'RFQ1',
                'RFQ 2' => 'RFQ2',
                'RFQ 3' => 'RFQ3',
                'Abstract of Quotation' => 'AQ',
                'Purchase Order' => 'PO',
                'Notice of Award' => 'NOA',
                'Notice to Proceed' => 'NTP'
            ];

            foreach ($stagesOrder as $stageName => $shortForm) {
                $insertCreatedAt = ($stageName === 'Purchase Request') ? date("Y-m-d H:i:s") : null;
                $stmtInsertStage = $pdo->prepare("INSERT INTO tblproject_stages (projectID, stageName, createdAt) VALUES (?, ?, ?)");
                $stmtInsertStage->execute([$newProjectID, $stageName, $insertCreatedAt]);
            }
            $pdo->commit();
            // Removed header redirect on success. The page will naturally reload on POST
            // so the new project should appear.
            // A success message could be set here like $projectSuccess = "Project added successfully!";
        } catch (PDOException $e) {
            $pdo->rollBack();
            $projectError = "Error adding project: " . $e->getMessage();
        }
    }
}

/* ---------------------------
    Retrieve Projects (with optional search)
------------------------------ */
$search = "";
if (isset($_GET['search'])) {
    $search = trim($_GET['search']);
}

// Modified SQL query to fetch additional stage information.
$sql = "SELECT p.*, u.firstname, u.lastname,
        (SELECT isSubmitted FROM tblproject_stages WHERE projectID = p.projectID AND stageName = 'Notice to Proceed') AS notice_to_proceed_submitted,
        (SELECT s.stageName FROM tblproject_stages s WHERE s.projectID = p.projectID AND s.isSubmitted = 0
            ORDER BY FIELD(s.stageName, 'Purchase Request','RFQ 1','RFQ 2','RFQ 3','Abstract of Quotation','Purchase Order','Notice of Award','Notice to Proceed') ASC
            LIMIT 1) AS first_unsubmitted_stage
        FROM tblproject p
        JOIN tbluser u ON p.userID = u.userID";

if ($search !== "") {
    $sql .= " WHERE p.projectDetails LIKE ? OR p.prNumber LIKE ?";
}
$sql .= " ORDER BY COALESCE(p.editedAt, p.createdAt) DESC";
$stmt = $pdo->prepare($sql);
if ($search !== "") {
    $stmt->execute(["%$search%", "%$search%"]);
} else {
    $stmt->execute();
}
$projects = $stmt->fetchAll();

/* ---------------------------
    Calculate Statistics
------------------------------ */
$totalProjects = count($projects);
$finishedProjects = 0;

foreach ($projects as $project) {
    if ($project['notice_to_proceed_submitted'] == 1) {
        $finishedProjects++;
    }
}

$ongoingProjects = $totalProjects - $finishedProjects;
$percentageDone = ($totalProjects > 0) ? round(($finishedProjects / $totalProjects) * 100, 2) : 0;
$percentageOngoing = ($totalProjects > 0) ? round(($ongoingProjects / $totalProjects) * 100, 2) : 0;

// Define $showTitleRight for the header.php
// Set to false for the dashboard to remove "Bids and Awards Committee Tracking System"
$showTitleRight = false; 
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dashboard - DepEd BAC Tracking System</title>
    <link rel="stylesheet" href="assets/css/Index.css">    
    <link rel="stylesheet" href="assets/css/background.css">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/5/w3.css">
    
</head>
<body>
    <?php
    $showTitleRight = false; // Keep this false for dashboard
    include 'header.php';
    ?>

    <div class="main-content-wrapper">
        <div class="table-top-bar">
            <div class="left-controls">
                <button class="add-pr-button" id="showAddProjectForm">
                    <img src="assets/images/Add_Button.png" alt="Add" class="add-pr-icon">
                    Add Project
                </button>
            </div>

            <div class="center-search">
                <input type="text" id="searchInput" class="dashboard-search-bar" placeholder="Search by PR Number or Project Details..." value="<?php echo htmlspecialchars($search); ?>">
            </div>

            <div class="right-controls">
                <button class="view-stats-button" onclick="loadAndShowStatistics()">
                    <img src="assets/images/stats_icon.png" alt="Stats" style="width:24px;height:24px;">
                    View Statistics
                </button>
            </div>
        </div>

        <?php if (!empty($deleteProjectError)): // Display delete error on main page ?>
            <p style="color: red; text-align: center; margin-top: 10px;"><?php echo htmlspecialchars($deleteProjectError); ?></p>
        <?php endif; ?>
        

        <div class="container" style="padding: 3vh 2.5vw;">
            <table class="w3-table-all w3-hoverable dashboard-table">
                <thead>
                    <tr class="w3-red">
                        <th style="width:100px;">PR Number</th>
                        <th style="width:300px;">Project Details</th>
                        <th style="100px;">Created By</th>
                        <th style="120px;">Date Created</th>
                        <th style="120px;">Date Edited</th>
                        <th style="100px;">Status</th>
                        <th style="120px;">Actions</th>
                    </tr>
                </thead>
                <tbody>

                </tbody>
                    <?php if (count($projects) > 0): ?>
                        <?php foreach ($projects as $project): ?>
                            <tr>
                                <td data-label="PR Number" class="pr-number-cell">
                                    <?php echo htmlspecialchars($project['prNumber']); ?>
                                </td>
                                <td data-label="Project Details">
                                    <?php
                                        $details = htmlspecialchars($project['projectDetails']);
                                        $maxLength = 80; // Adjust as needed (character count)
                                        $id = 'details_' . $project['projectID'];
                                        if (mb_strlen($details) > $maxLength) {
                                            $short = mb_substr($details, 0, $maxLength) . '...';
                                            echo '<span class="project-details-short" id="' . $id . '_short">' . $short . ' <button class="see-more-btn" onclick="showFullDetails(\'' . $id . '\')">See more</button></span>';
                                            echo '<span class="project-details-full" id="' . $id . '_full" style="display:none;">' . $details . ' <button class="see-less-btn" onclick="hideFullDetails(\'' . $id . '\')">See less</button></span>';
                                        } else {
                                            echo $details;
                                        }
                                    ?>
                                </td>
                                <td data-label="Created By">
                                    <?php
                                        if (!empty($project['firstname']) && !empty($project['lastname'])) {
                                            echo htmlspecialchars(substr($project['firstname'], 0, 1) . ". " . $project['lastname']);
                                        } else {
                                            echo "N/A";
                                        }
                                    ?>
                                </td>
                                <td data-label="Date Created"><?php echo date("m-d-Y", strtotime($project['createdAt'])); ?></td>
                                <td data-label="Date Edited"><?php echo date("m-d-Y", strtotime($project['editedAt'])); ?></td>
                                <td data-label="Status">
                                    <?php
                                        if ($project['notice_to_proceed_submitted'] == 1) {
                                            echo 'Finished';
                                        } else {
                                            echo htmlspecialchars($project['first_unsubmitted_stage'] ?? 'No Stages Started');
                                        }
                                    ?>
                                </td>
                                <td data-label="Actions">
                                    <a href="edit_project.php?projectID=<?php echo $project['projectID']; ?>" class="edit-project-btn" title="Edit Project" style="margin-right: 5px;">
                                        <img src="assets/images/Edit_Icon.png" alt="Edit Project" style="width:24px;height:24px;">
                                    </a>
                                    <?php if (isset($_SESSION['admin']) && $_SESSION['admin'] == 1): ?>
                                    <a href="index.php?deleteProject=<?php echo $project['projectID']; ?>" class="delete-btn" onclick="return confirm('Are you sure you want to delete this project and all its stages?');" title="Delete Project">
                                        <img src="assets/images/delete.png" alt="Delete Project" style="width:24px;height:24px;">
                                    </a>
                                    <?php endif; ?>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="7" id="noResults" style="display: block;">No projects found.</td> </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>

    <div id="addProjectModal" class="modal">
        <div class="modal-content">
            <span class="close" id="addProjectClose">&times;</span>
            <h2>Add Project</h2>
            <?php if (!empty($projectError)): // Display add project error inside the modal ?>
                <p style="color: red; text-align: center; margin-bottom: 10px;"><?php echo htmlspecialchars($projectError); ?></p>
            <?php endif; ?>
            <form id="addProjectForm" action="index.php" method="post">
                <label for="prNumber">Project Number (PR Number)*</label>
                <input type="text" name="prNumber" id="prNumber" required>
                <label for="projectDetails">Project Details*</label>
                <textarea name="projectDetails" id="projectDetails" rows="4" required></textarea>
                <button type="submit" name="addProject">Add Project</button>
            </form>
        </div>
    </div>

    <div id="statsModal" class="modal">
        <div class="modal-content stats-modal">
            <span class="close" id="statsClose">&times;</span>
            <div id="statsModalContentPlaceholder">
                <p style="text-align: center; margin-top: 20px;">Loading statistics...</p>
            </div>
        </div>
    </div>

    <script>
        // Define modal elements globally at the very top of your script
        // This is CRITICAL for them to be recognized by subsequent functions/listeners.
        const addProjectModal = document.getElementById('addProjectModal');
        const statsModal = document.getElementById('statsModal');
        const statsModalContentPlaceholder = document.getElementById('statsModalContentPlaceholder');
        const statsClose = document.getElementById('statsClose'); // The 'X' button to close stats modal
        const addProjectClose = document.getElementById('addProjectClose'); // The 'X' button to close add project modal

        // --- Show Add Project Modal on page load if there was an error ---
        document.addEventListener('DOMContentLoaded', function() {
            <?php if (!empty($projectError)): ?>
                if (addProjectModal) {
                    addProjectModal.style.display = 'block';
                    // Re-populate form fields on error to retain user input
                    document.getElementById('prNumber').value = "<?php echo htmlspecialchars($_POST['prNumber'] ?? ''); ?>";
                    document.getElementById('projectDetails').value = "<?php echo htmlspecialchars($_POST['projectDetails'] ?? ''); ?>";
                }
            <?php endif; ?>
        });

        // --- Modal Closing Logic (Escape Key) ---
        document.addEventListener('keydown', function(event) {
            if (event.key === "Escape") {
                // Check if the element exists and is displayed before trying to hide it
                if (addProjectModal && addProjectModal.style.display === 'block') {
                    addProjectModal.style.display = 'none';
                }
                if (statsModal && statsModal.style.display === 'block') {
                    statsModal.style.display = 'none';
                    // Clear content when closed by Escape
                    if (statsModalContentPlaceholder) {
                        statsModalContentPlaceholder.innerHTML = '';
                    }
                }
            }
        });

        // --- Search functionality for filtering projects. ---
        document.getElementById("searchInput").addEventListener("keyup", function() {
            let query = this.value.toLowerCase().trim();
            let rows = document.querySelectorAll("table.dashboard-table tbody tr");
            let visibleCount = 0;
            const displayStyle = window.matchMedia("(max-width: 500px)").matches ? "block" : "table-row";
            rows.forEach(row => {
                let prNumber = row.children[0].textContent.toLowerCase();
                let projectDetails = row.children[1].textContent.toLowerCase();
                if (prNumber.includes(query) || projectDetails.includes(query)) {
                    row.style.display = displayStyle;
                    visibleCount++;
                } else {
                    row.style.display = "none";
                }
            });
            const noResultsDiv = document.getElementById("noResults");
            // Only show "No results" if the search query is not empty and no rows are visible
            noResultsDiv.style.display = (visibleCount === 0 && query !== '') ? "block" : "none";
        });


        // --- Add Project Modal logic ---
        // Assuming you have a button with id="showAddProjectForm" to open this modal
        const showAddProjectFormButton = document.getElementById('showAddProjectForm');
        if (showAddProjectFormButton) { // Check if the button exists
            showAddProjectFormButton.addEventListener('click', function() {
                if (addProjectModal) { // Check if modal element exists
                    addProjectModal.style.display = 'block';
                    // Clear any previous error messages when opening the modal for a new attempt
                    const errorParagraph = addProjectModal.querySelector('p[style*="color: red"]');
                    if (errorParagraph) {
                        errorParagraph.remove();
                    }
                }
            });
        }
        if (addProjectClose) { // Check if the close button exists
            addProjectClose.addEventListener('click', function() {
                if (addProjectModal) { // Check if modal element exists
                    addProjectModal.style.display = 'none';
                }
            });
        }


        // --- Statistics Modal (New dynamic loading function) ---
        // This function will be called directly by the button's onclick="loadAndShowStatistics()"
        function loadAndShowStatistics() {
            // Display a loading message immediately
            if (statsModalContentPlaceholder) {
                statsModalContentPlaceholder.innerHTML = '<p style="text-align: center; margin-top: 20px;">Loading statistics...</p>';
            }
            if (statsModal) {
                statsModal.style.display = 'block'; // Show the modal frame immediately
            }

            fetch('statistics.php')
                .then(response => {
                    if (!response.ok) {
                        // Log the status and text of the bad response
                        console.error('Network response was not ok:', response.status, response.statusText);
                        // Try to get more details if it's an HTTP error (e.g., 404, 500)
                        return response.text().then(text => {
                            throw new Error('HTTP error! Status: ' + response.status + ' - ' + text);
                        });
                    }
                    return response.text();
                })
                .then(html => {
                    if (statsModalContentPlaceholder) {
                        statsModalContentPlaceholder.innerHTML = html; // Insert the fetched HTML and CSS
                    }
                })
                .catch(error => {
                    console.error('There has been a problem with your fetch operation:', error);
                    if (statsModalContentPlaceholder) {
                        statsModalContentPlaceholder.innerHTML = '<p style="color: red; text-align: center; margin-top: 20px;">Failed to load statistics. Please try again.<br>Error: ' + error.message + '</p>';
                    }
                    if (statsModal) {
                        statsModal.style.display = 'block'; // Ensure modal is visible to show error
                    }
                });
        }

        // --- Close Statistics Modal (X button) ---
        if (statsClose) { // Check if the close button exists
            statsClose.addEventListener('click', function() {
                if (statsModal) { // Check if modal element exists
                    statsModal.style.display = 'none';
                }
                if (statsModalContentPlaceholder) { // Clear content when closed by X button
                    statsModalContentPlaceholder.innerHTML = '';
                }
            });
        }

        // --- Handle clicks outside modals to close them ---
        document.addEventListener('click', function(event) {
            // Close Add Project Modal if click outside
            if (addProjectModal && event.target === addProjectModal) {
                addProjectModal.style.display = 'none';
            }
            // Close Stats Modal if click outside
            if (statsModal && event.target === statsModal) {
                statsModal.style.display = 'none';
                // Clear content when closed by outside click
                if (statsModalContentPlaceholder) {
                    statsModalContentPlaceholder.innerHTML = '';
                }
            }
        });

        function showFullDetails(id) {
            document.getElementById(id + '_short').style.display = 'none';
            document.getElementById(id + '_full').style.display = 'inline';
        }
        function hideFullDetails(id) {
            document.getElementById(id + '_full').style.display = 'none';
            document.getElementById(id + '_short').style.display = 'inline';
        }
    </script>
</body>
</html>