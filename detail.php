<?php 

    $connection = new mysqli("localhost","root","","uas_pbm");
    $data       = mysqli_query($connection, "select * from todolist_app where id=".$_GET['id']);
    $data       = mysqli_fetch_array($data, MYSQLI_ASSOC);

    echo json_encode($data);