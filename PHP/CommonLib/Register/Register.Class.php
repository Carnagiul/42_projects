<?php

Class Register
{
	public static $table_default = "users_default";
	public static $table_gmail = "users_gmail";
	public static $table_linkedin = "users_linkedin";
	public static $table_twitter = "users_twitter";

	function __construct()
	{

	}

	function __destruct()
	{

	}

	public static function verifyRegistation($name, $mail, $pass, $pass2)
	{
		if ($name == NULL)
			return (json_encode(array("type" => "error", "reason" => "undefined_name")));
		if ($mail == NULL)
			return (json_encode(array("type" => "error", "reason" => "undefined_mail")));
		if (filter_var($mail, FILTER_VALIDATE_EMAIL) == FALSE)
			return (json_encode(array("type" => "error", "reason" => "wrong_mail")));
		if ($pass == NULL)
			return (json_encode(array("type" => "error", "reason" => "pass_not_exist")));
		if ($pass2 == NULL)
			return (json_encode(array("type" => "error", "reason" => "pass_not_exist")));
		if ($pass != $pass2)
			return (json_encode(array("type" => "error", "reason" => "pass_not_same")));
		return (NULL);
	}

	public static function registerNewUser($name, $mail, $pass, $pass2, $type)
	{
		if (($ret = self::verifyRegistation($name, $mail, $pass, $pass2)) != NULL)
			return ($ret);
	}
}

?>