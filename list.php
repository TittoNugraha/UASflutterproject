<?php 

    $connection = new mysqli("localhost","root","","uas_pbm");
    $data       = mysqli_query($connection, "select * from todolist_app");
    $data       = mysqli_fetch_all($data, MYSQLI_ASSOC);

    echo json_encode($data);