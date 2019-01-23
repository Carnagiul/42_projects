<?php


Class ImgUplaod
{
	public static $type = array("jpg");
	public static $need = array("tmp_name", "type", "name");
	public static $limit = array("min_width" => 100, "max_width" => 4096, "min_height" => 100, "max_height" => 4096);
	public $file;
	public $name;
	public $type;
	public $width;
	public $height;

	public static function remove_accents($str)
	{
		$charset = "utf-8";

		$str = htmlentities($str, ENT_NOQUOTES, $charset);
		$str = str_replace('\'', '_', $str);
		$str = str_replace(' ', '_', $str);


		return ($str);	
	}

	public function __construct($form)
	{
		if (isset($_FILES))
		{
			foreach (self::$need as $key)
			{
				if (!(isset($_FILES["image"][$key])))
					return (NULL);
			}
			$ok = false;
			$this->file = $_FILES[$form]["tmp_name"];
			$this->name = strtolower($_FILES[$form]["name"]);
			$this->type = self::remove_accents($_FILES[$form]["type"]);
			foreach (self::$type as $type)
			{
				if ($type == $this->type)
				{
					$ok = true;
					break ;
				}
			}
			if ($ok == false)
				return (NULL);
			if (!(is_uploaded_file($this->file)))
				return (NULL);
			list($this->width, $this->height) = getimagesize($this->file);
			if ($this->width <= self::$limit["min_width"] || $this->width >= self::$limit["max_width"])
				return (NULL);
			if ($this->height <= self::$limit["min_height"] || $this->height >= self::$limit["max_height"])
				return (NULL);
		}

		public function renameFile($name)
		{
			$this->name = $name;
		}

		public function finish()
		{
			global $uri_site2;
	
			$filename = $this->name . "." . $this->type;
			$file_path = $uri_site2 . "/article/";
			if (file_exists($file_path))
				unlink($file_path);
			move_uploaded_file($filename, $file_path);
		}
	}
}

?>
