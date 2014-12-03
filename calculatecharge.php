<?php

	function connect_db(){
		$username = "root";
		$password = "741852963";
		$server= "localhost";
		$database = "auditing";

		$conn = new mysqli($server, $username, $password, $database);
		if ($conn->connect_error) {
			die ("connection failed: " . $conn->connect_error);
		}else{
			echo "connection successful<br>";
			return $conn;
		}
	}
	//get list of users from users table
	//make function calculate program_charge
	function calculate_program_charge(){
	        $conn = connect_db();
                
		$sql = "UPDATE users SET program_charge=0";
		$conn->query($sql);
		$sql = "SELECT * FROM users";
                $result = $conn->query($sql);

		if($result->num_rows > 0) {
                        while($row = $result->fetch_assoc()){ //loop through all users
				//echo "<br>ROWUSERNAME: ".$row['username']." END<br><br><br>: ";
				//reset program_charge to 0;
				//$var = 0.0;
				//$sql = "UPDATE users SET program_charge=0 WHERE username='".$row['username']."'";
				//if($conn->query($sql) === TRUE){
					//echo "reset program charge";
				//} //set program charge to 0 so that we can tally up all the programs again
				//else {
				//	echo $conn->error;
				//}

//				$sql = "SELECT * FROM users WHERE username='".$row['username']."'";
				//$result10 = $conn->query($sql);
				//if($result10->num_row > 0){
				//	while($row10 = $result10->fetch_assoc()){
				//		echo "<br><br><br>name:".$row10['username']." resetcharge: ".$row10['program_charge'];
				//	}
				//}

				$sql = "SELECT * FROM user_programs WHERE username='".$row['username']."'";
				$result2 = $conn->query($sql);
				if($result2->num_rows > 0) {
					while($row2 = $result2->fetch_assoc()){
						//echo $row['process_name']." : ";
						$sql = "SELECT * FROM paid_programs WHERE process_name='".$row2['process_name']."'";
						$result3 = $conn->query($sql);
						//echo $result3->num_rows;
						while($row3 = $result3->fetch_assoc()){
							//this will only  run once if everything went well in the bash script (removing dups)
							//there is a match
							//get the cost, add it to the result thing
							$charge=$row3['cost']+$row['program_charge'];
							$sql = "UPDATE users SET program_charge='".$charge."' WHERE username='".$row['username']."'";
							//$sql = "INSERT INTO users (program_charge) VALUES('$charge') WHERE username='".$row['username']."'";
							if ($conn->query($sql) === TRUE){
								//echo "added program_charge";
								//$sql = "UPDATE user_programs SET charge='TRUE' WHERE 
								//	username='".$row['username']."'";
								//if ($conn->query($sql) === TRUE){
								//	echo "set charge";
								//}else{
								//	echo "error";
								//}
							}else{
								echo $conn->error;
							}
							//echo $charge;
						}
					}
				}else{
					//echo "nothing sorry<br>";
				}

				// $blocks=$row["used_blocks"];
                               // $bytes=$blocks*512; //number of blocks to bytes
                               // $mb = $bytes/pow(1024,2);
                               // $charge = $mb/10;

                               // $username=$row["username"];
                               // $sql = "UPDATE users SET disk_charge=$charge WHERE username='$username'";
                               // echo "<br>".$sql;
                               // if($conn->query($sql) === TRUE){
                               //         echo "updated charge<br>";
                               // } else {
                               //         echo "error updating charge<br>";
                               // }
                        }
                } else {
                        echo "0 results";
                }
                $conn->close();

		//that will get all from user_programs where username = username and filter
		//get all paid_programs and get a list of programs that the user should pay for 
                //then from that list, remove all dups from the same day 
                //use that final list of calculate charge for programs 
	}
	//make functi9on that will calculate charge based on number of blocks
	function calculate_usedspace_charge(){
		//ONE BLOCK IS 512 bytes
		$conn = connect_db();
		$sql = "SELECT * FROM users";
		$result = $conn->query($sql);

		 if($result->num_rows > 0) {
                        while($row = $result->fetch_assoc()){
                                $blocks=$row["used_blocks"];
				$bytes=$blocks*512; //number of blocks to bytes
				$mb = $bytes/pow(1024,2);
				$charge = $mb/10;

                                $username=$row["username"];
                                $sql = "UPDATE users SET disk_charge=$charge WHERE username='$username'";
                                echo "<br>".$sql;
                                if($conn->query($sql) === TRUE){
                                        echo "updated charge<br>";
                                } else {
                                        echo "error updating charge<br>";
                                }
                        }
                } else {
                        echo "0 results";
                }
                $conn->close();
	}

	function calculate_logintime_charge(){
		$conn = connect_db();
		$sql = "SELECT * FROM users";
		$result = $conn->query($sql);

		if($result->num_rows > 0) {
			while($row = $result->fetch_assoc()){
				$time=$row["total_login_time"];
				$charge = $time/10; //divides time by 10 to generate cost
				$username=$row["username"];
				$sql = "UPDATE users SET time_charge=$charge WHERE username='$username'";
				echo "<br>".$sql;
				if($conn->query($sql) === TRUE){
					echo "updated charge<br>";
				} else {
					echo "error updating charge<br>";
				}
			}
		} else {
			echo "0 results";
		}
		$conn->close();
	}

calculate_logintime_charge();
calculate_usedspace_charge();
calculate_program_charge();


?>
