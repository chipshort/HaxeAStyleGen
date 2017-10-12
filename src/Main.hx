package;

import format.FormatterFile;
import haxe.Json;
import neko.Lib;

using util.Lambda;

/**
 * ...
 * @author Christoph Otter
 */
class Main 
{
	
	static function main()
	{
		//TODO: localization
		//TODO: example codes
		var file = new FormatterFile("$AStyle", "haxe");
		file.Categories.push(createTabs());
		file.Categories.push(createBraces());
		file.Categories.push(createPadding());
		file.Categories.push(createFormatting());
		
		file.AdditionalArgs = ["--mode=cs"];
		file.Code = CompileTime.readFile("Example.hx");
		
		Lib.println(Json.stringify(file, null, "    "));
	}
	
	static function createTabs() : Category
	{
		var cat = new Category("Tabs / Indents");
		//cat.Code = "//TODO: example code";
		
		var use = new FormatOption("Tabs:", new Select());
		var useSpaces = new SelectData();
		var useTabs = new SelectData();
		var forceTabs = new SelectData();
		
		useSpaces.Name = "Spaces";
		useSpaces.Arg = "--indent=spaces=${width}";
		useTabs.Name = "Tabs";
		useTabs.Arg = "--indent=tab=${width}";
		forceTabs.Name = "Force Tabs";
		forceTabs.Arg = "--indent=force-tab=${width}";
		
		use.SelectData = [useSpaces, useTabs, forceTabs];
		
		var tabWidth = new FormatOption("Width:", new Number(2, 20, 4));
		
		var indentSwitches = new FormatOption("Indent switches", new Check("--indent-switches"));
		
		var indentCaseBlocks = new FormatOption("Indent case blocks", new Check("--indent-cases"));
		
		var indentConditionals = new FormatOption("Indent conditional compilation", new Check("--indent-preproc-cond"));
		
		cat.Options.push(use);
		cat.Options.push(tabWidth);
		cat.Options.push(indentSwitches);
		cat.Options.push(indentCaseBlocks);
		cat.Options.push(indentConditionals);
		
		return cat;
	}
	
	static function createPadding() : Category
	{
		var cat = new Category("Padding");
		//cat.Code = "//TODO: example code";
		
		var padBlocks = new FormatOption("Pad blocks", new Check("--break-blocks"));
		padBlocks.CheckData.Suboptions = [new FormatOption("Pad all blocks", new Check("--break-blocks=all"))];
		
		var padCommas = new FormatOption("Pad commas", new Check("--pad-comma"));
		
		var padHeaders = new FormatOption("Pad headers", new Check("--pad-header"));
		
		var deleteEmptyLines = new FormatOption("Delete empty lines", new Check("--delete-empty-lines"));
		deleteEmptyLines.CheckData.Unchecks = ["fillEmptyLines"];
		
		var fillEmptyLines = new FormatOption("Fill empty lines", new Check("--fill-empty-lines"));
		fillEmptyLines.CheckData.Unchecks = ["deleteEmptyLines"];
		
		var padParensIn = new FormatOption("Pad inside of parentheses", new Check("--pad-paren-in"));
		
		var padParensOut = new FormatOption("Pad outside of parentheses", new Check("--pad-paren-out"));
		
		cat.Options.push(padBlocks);
		cat.Options.push(padCommas);
		cat.Options.push(padHeaders);
		cat.Options.push(deleteEmptyLines);
		cat.Options.push(fillEmptyLines);
		cat.Options.push(padParensIn);
		cat.Options.push(padParensOut);
		
		return cat;
	}
	
	static function createFormatting() : Category
	{
		var cat = new Category("Formatting");
		cat.Code = "//TODO: example code";
		
		var breakElseIfs = new FormatOption("Break else ifs", new Check("--break-elseifs"));
		
		var keepOneLineBlocks = new FormatOption("Keep one line blocks", new Check("--keep-one-line-blocks"));
		keepOneLineBlocks.CheckData.Unchecks = ["addBracesToOneLineConditionals"];
		
		var keepOneLineStatements = new FormatOption("Keep one line statements", new Check("--keep-one-line-statements"));
		
		cat.Options.push(breakElseIfs);
		cat.Options.push(keepOneLineBlocks);
		cat.Options.push(keepOneLineStatements);
		return cat;
	}
	
	
	static function createBraces() : Category
	{
		var cat = new Category("Braces");
		cat.Code = "//TODO: example code";
		
		var style = new FormatOption("Brace style:", new Select());
		style.SelectData = getBraceStyles();
		
		var attachClasses = new FormatOption("Attach classes", new Check("--attach-classes"));
		
		var braces = new FormatOption("Braces:", new Select());
		var addBraces = new FormatOption("Add braces to one line conditionals", new Check("--add-brackets"));
		addBraces.CheckData.Suboptions = [new FormatOption("Add braces on the same line", new Check("--add-one-line-brackets"))];
		addBraces.CheckData.Unchecks = ["removeBracesFromConditionals", "keepOneLineBlocks"];
		
		var removeBraces = new FormatOption("Remove braces from conditionals", new Check("--remove-brackets"));
		removeBraces.CheckData.Unchecks = ["addBracesToOneLineConditionals"];
		
		var breakClosingBraces = new FormatOption("Break closing brackets", new Check("--break-closing-brackets"));
		
		cat.Options.push(style);
		cat.Options.push(attachClasses);
		cat.Options.push(addBraces);
		cat.Options.push(removeBraces);
		cat.Options.push(breakClosingBraces);
		
		return cat;
	}
	
	static function getBraceStyles() : Array<SelectData>
	{
		var keys = [
			"Allman",
			"Java",
			"Kernighan & Ritchie",
			"Stroustrup",
			"Whitesmith",
			"VTK",
			"Banner",
			"GNU",
			"Linux",
			"Horstmann",
			"One True Brace",
			"Google",
			//"Mozilla",
			"Pico",
			"Lisp"			
		];
		var map : Map<String, String> = [
			"Allman" => "allman",
			"Java" => "java",
			"Kernighan & Ritchie" => "kr",
			"Stroustrup" => "stroustrup",
			"Whitesmith" => "whitesmith",
			"VTK" => "vtk",
			"Banner" => "banner",
			"GNU" => "gnu",
			"Linux" => "linux",
			"Horstmann" => "horstmann",
			"One True Brace" => "otbs",
			"Google" => "google",
			//"Mozilla" => "mozilla",
			"Pico" => "pico",
			"Lisp" => "lisp"
		];
		
		var checkBreakClosing = "breakClosingBrackets";
		var checkAttachClasses = "attachClasses";
		var checkRemoveBrackets = "removeBracesFromConditionals";
		
		var disables : Map<String, Array<String>> = [
			"Java" => [checkAttachClasses],
			"Stroustrup" => [checkAttachClasses],
			"Whitesmith" => [checkBreakClosing],
			"VTK" => [checkBreakClosing],
			"Banner" => [checkBreakClosing, checkAttachClasses],
			"GNU" => [checkBreakClosing],
			"Horstmann" => [checkBreakClosing],
			"One True Brace" => [checkRemoveBrackets],
			"Google" => [checkBreakClosing, checkAttachClasses],
			//"Mozilla" => [checkBreakClosing],
			"Pico" => [checkBreakClosing],
			"Lisp" => [checkBreakClosing, checkAttachClasses]
		];
		
		return keys.map(function (key) return createBraceStyle(key, map[key], disables[key]) );
	}
	
	static function createBraceStyle(name: String, option: String, ?disables : Array<String>) : SelectData
	{
		var data = new SelectData();
		data.Name = name;
		data.Arg = "--style=" + option;
		if (disables != null) data.Disables = disables;
		
		return data;
	}
	
}