<?php

// Include the file containing the database connection code
require './create-table.php';
require './insert-table.php';
require './select-table.php';

//CSS style
echo '<style>
    .title-text {
        background-color: #f1f1f1;
        text-align: center;
        font-weight: bold;
        font-size: 20px;
        color: black;
        font-family: "Times New Roman", Times, serif;
        text-transform: uppercase;
        padding: 7px;
        margin-bottom: 5px;
    }
    .body-text {
        background-color: white;
        text-align: center;
        font-size: 16px;
        color: black;
        font-family: "Times New Roman", Times, serif;
        padding: 7px;
        display: flex;
        align-items: center;
    }
    .body-text i {
        margin-right: 5px;
        height: 16px;
        width: auto;
    }
    ul.a{
        list-style-type: circle;
    }
</style>';

echo '<head>
	    <title>Curriculum Vitae</title>
	    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
            <link rel="shortcut icon" href="https://cdn.icon-icons.com/icons2/1001/PNG/512/ilustracoes_04-12_icon-icons.com_75471.png">
      </head>';

echo '<div class="title-text">';
echo "<span>$name</span><br>";
echo '</div>';

echo '<div class="body-text">';
echo "<span>$aboutMe </span><br>";
echo '</div>';

echo '<div class="title-text">';
echo "<span>Contact Me</span><br>";
echo '</div>';

echo '<div class="body-text">';
echo "<i class='fa'>&#xf098; <span>$telpNum</span><br>";
echo '</div>';

echo '<div class="body-text">';
echo "<i class='fa'>&#xf199; <span>$email</span><br>";
echo '</div>';

echo '<div class="body-text">';
echo "<i class='fa'>&#xf08c; <span>$socMed1</span><br>";
echo '</div>';

echo '<div class="body-text">';
echo "<i class='fa'>&#xf041; <span>$address</span><br>";
echo '</div>';

echo '<div class="title-text">';
echo "<span>Education</span><br>";
echo '</div>';

$space = '&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp';
echo '<div class="body-text">';
echo "<i class='fa'>&#xf19d; <span>$education1</span>";
echo '</div>';
echo "<div><span>$space GPA 3.32 Out of 4.00</span></div>";
