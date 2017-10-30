//#valid time or not
//#Version 4 load
//#problem here
module jtask.taskbb;

private
{
	import std.stdio;
	import core.stdc.stdio;
	import std.string;
	import std.datetime;
	import std.conv;
	
	import jtask.basebb;
}

/++
 + Task Bare Bones
 +/
class Taskbb {
private:
	int _id;
	string _taskString;
	TimeLength _length;
	string _comment;
	bool _displayStartTimeFlag; //#valid time or not 1/2
	bool _displayEndTimeFlag;

///
	struct JDateTime {
		int day, month, year, hour, minute, second;
	}
	JDateTime _jDateTime;
///
	DateTime _dateTime; // day, month, year, time taken (note: user sets this variable) //#what is time taken
	DateTime _endTime;
public:
	/// task constructor sets task with current date and time
	this(int id = 0, string taskString = "")
	{
		_id = id;
		_taskString = taskString;
		_length = TimeLength(0,0,0); // is any way
		_comment = ""; // is any way
		_dateTime = cast(DateTime)Clock.currTime();
		
		_displayStartTimeFlag = false;
		_displayEndTimeFlag   = false;
	}

	@property {
		int id() { return _id; } // getter
		 string taskString() { return _taskString; } // getter
		 TimeLength timeLength() { return _length; } // getter
		 string comment() { return _comment; } // getter
		 DateTime dateTime() { return _dateTime; } // getter
		 bool displayStartTimeFlag() { return _displayStartTimeFlag; } // getter //#valid time or not 2/2
		 DateTime endTime() { return _endTime; } // getter
		 bool displayEndTimeFlag() { return _displayEndTimeFlag; } // getter //#valid time or not 2/2
	 }

	// setAll
	this( int id, string taskString, TimeLength length, string comment, DateTime dateTime,
		  bool displayStartTimeFlag, DateTime endTime, bool displayEndTimeFlag ) {
		_id = id;
		_taskString = taskString;
		_length = length;
		_comment = comment;
		_dateTime = dateTime;
		_displayStartTimeFlag = displayStartTimeFlag;
		_endTime = endTime;
		_displayEndTimeFlag = displayEndTimeFlag;
	}
	
	/// Load as task part of binary file
	void loadTaskPart( FILE* pfile, int version0 ) { // Taskbb[] tasks, int version0) {
		switch( version0 ) {
			case 3: // old
				// layout: [1 int id][2 struct timelength][3 int comment length][4 string comment string]
				int charCount;
				char[] text;
				fread(&_id, 1, _id.sizeof, pfile); // 1) read task id
				//#problem here
				//_taskString = tasks[_id].taskString; // set task -- Note: info from parameter not binary file
				fread(&_length, 1, _length.sizeof, pfile); // 2) read task time length
				fread(&charCount, 1, charCount.sizeof, pfile); // 3) read number for comment char count
				text.length = charCount;
				fread(text.ptr, text.length, byte.sizeof, pfile); // 4) read comment text
				_comment = text.idup; // set comment text

				// (int day)(int month)(int year)(int weekday)(int hour(0 - 23)(int minute)(int second)
				// hour is from 1 - 24 actually - or not.
				with (_jDateTime)
				{
					fread( &day,       1, year.sizeof,      pfile ); // read day
					fread( &month,     1, month.sizeof,     pfile ); // read month
					fread( &year,      1, year.sizeof,      pfile ); // read year
					fread( &hour,      1, hour.sizeof,      pfile ); // read hour
					fread( &minute,    1, minute.sizeof,    pfile ); // read minute
					fread( &second,    1, second.sizeof,    pfile ); // read second
					//writeln(_jDateTime, " <- ", day, ' ', month, ' ', year);
				}
				fread(
					/+ value: +/         &_displayStartTimeFlag,
					/+ amount: +/        1,
					/+ size in bytes: +/ _displayStartTimeFlag.sizeof,
					/+ stream: +/        pfile ); // read tod (time of day) display switch
				with( _dateTime ) {
					_dateTime = DateTime( year, month, day, hour, minute, second );
				}
				break;
			//#Version 4 load
			case 4: // near old
				// layout: [1 int id][2 struct timelength][3 int comment length][4 string comment string]
				int charCount;
				char[] text;
				fread( &_id,       1,           _id.sizeof,       pfile ); // 1) read task id
				fread( &charCount, 1,           charCount.sizeof, pfile );
				text.length = charCount;
				fread( text.ptr,   text.length, byte.sizeof,      pfile );
				_taskString = text.idup;
				//#problem here
				//_taskString = tasks[_id].taskString; // set task -- Note: info from parameter not binary file
				fread(&_length, 1, _length.sizeof, pfile); // 2) read task time length

				fread( &charCount,  1,           charCount.sizeof, pfile); // 3) read number for comment char count
				text.length = charCount;
				fread( text.ptr,    text.length, byte.sizeof,      pfile); // 4) read comment text
				_comment = text.idup; // set comment text

				// (int day)(int month)(int year)(int weekday)(int hour(0 - 23)(int minute)(int second)
				// hour is from 1 - 24 actually - or not.
				with (_jDateTime) // start/time time
				{
					fread( &day,       1, year.sizeof,      pfile ); // read day
					fread( &month,     1, month.sizeof,     pfile ); // read month
					fread( &year,      1, year.sizeof,      pfile ); // read year
					fread( &hour,      1, hour.sizeof,      pfile ); // read hour
					fread( &minute,    1, minute.sizeof,    pfile ); // read minute
					fread( &second,    1, second.sizeof,    pfile ); // read second
					//writeln(_jDateTime, " <- ", day, ' ', month, ' ', year);
				}
				fread(
					/+ value: +/         &_displayStartTimeFlag,
					/+ amount: +/        1,
					/+ size in bytes: +/ _displayStartTimeFlag.sizeof,
					/+ stream: +/        pfile ); // read tod (time of day) display switch

				static bool once = false;
				with( _jDateTime ) {
					if (once == false)
						writeln(format("year-%s month-%s day-%s hour-%s minute-%s second-%s "
							, year, month, day, hour, minute, second));
					_dateTime = DateTime( year, month, day, hour, minute, second );
				}
				once = true;
				break; // version 4
			case 5:
				// layout: [1 int id][2 struct timelength][3 int comment length][4 string comment string]
				int charCount;
				char[] text;
				fread( &_id,       1,           _id.sizeof,       pfile ); // 1) read task id
				fread( &charCount, 1,           charCount.sizeof, pfile );
				text.length = charCount;
				fread( text.ptr,   text.length, byte.sizeof,      pfile );
				_taskString = text.idup;
				//#problem here
				//_taskString = tasks[_id].taskString; // set task -- Note: info from parameter not binary file
				fread(&_length, 1, _length.sizeof, pfile); // 2) read task time length
				fread( &charCount,  1,           charCount.sizeof, pfile); // 3) read number for comment char count
				text.length = charCount;
				fread( text.ptr,    text.length, byte.sizeof,      pfile); // 4) read comment text
				_comment = text.idup; // set comment text

				// (int day)(int month)(int year)(int weekday)(int hour(0 - 23)(int minute)(int second)
				// hour is from 1 - 24 actually - or not.
				with (_jDateTime)
				{
					fread( &day,       1, year.sizeof,      pfile ); // read day
					fread( &month,     1, month.sizeof,     pfile ); // read month
					fread( &year,      1, year.sizeof,      pfile ); // read year
					fread( &hour,      1, hour.sizeof,      pfile ); // read hour
					fread( &minute,    1, minute.sizeof,    pfile ); // read minute
					fread( &second,    1, second.sizeof,    pfile ); // read second
				}
				with( _jDateTime ) {
					_dateTime = DateTime( year, month, day, hour, minute, second );
				}
				fread(
					/+ value: +/         &_displayStartTimeFlag,
					/+ amount: +/        1,
					/+ size in bytes: +/ _displayStartTimeFlag.sizeof,
					/+ stream: +/        pfile ); // read tod (time of day) display switch

				// (int day)(int month)(int year)(int weekday)(int hour(0 - 23)(int minute)(int second)
				// hour is from 1 - 24 actually - or not.
				with (_jDateTime)
				{
					fread( &hour,      1, hour.sizeof,      pfile ); // read hour
					fread( &minute,    1, minute.sizeof,    pfile ); // read minute
					fread( &second,    1, second.sizeof,    pfile ); // read second
				}
				with( _jDateTime ) {
					_endTime = DateTime( 1, 1, 1, hour, minute, second );
				}
				fread(
					/+ value: +/         &_displayEndTimeFlag,
					/+ amount: +/        1,
					/+ size in bytes: +/ _displayEndTimeFlag.sizeof,
					/+ stream: +/        pfile ); // read tod (time of day) display switch
			break; // version 5
			default:
				writeln( "Unsupported version!" );
			break;
		}
	}

	/// save task to bin file (just part of the bin file)
	void saveTaskPart(FILE* pfile)
	{
		// layout: [1 int id][2 TimeLength(int,int,int)][3 int comment length][4 string comment string]
		char[] text;
		int charCount;
		fwrite(&_id, 1, _id.sizeof, pfile); // 1) write task id (not file version)

		charCount = cast(int)_taskString.length;
		fwrite( &charCount, 1, charCount.sizeof, pfile );
		text = _taskString.dup;
		fwrite( text.ptr, text.length, byte.sizeof, pfile ); // label

		fwrite(&_length, 1, _length.sizeof, pfile); // 2) write task length (a struct obj)

		charCount = cast(int)_comment.length;
		fwrite(&charCount, 1, charCount.sizeof, pfile); // 3) write number of task string chars
		
		text = _comment.dup; // convert task 'string' to 'char[]' - and changes the text length
		fwrite(text.ptr, text.length, byte.sizeof, pfile); // 4) write comment text

		//#replace all this with a single number
		// (int day)(int month)(int year)(int weekday)(int hour(0 - 23)(int minute)(int second)
		with( _dateTime ) // start time
			_jDateTime = JDateTime( day, month, year, hour, minute, second );
		with (_jDateTime)
		{
			// fwrite([get address of], [number of times], [size in bytes], [file])
			fwrite(&day,     1, day.sizeof,     pfile); // write day
			fwrite(&month,   1, month.sizeof,   pfile); // write month
			fwrite(&year,    1, year.sizeof,    pfile); // write year
			fwrite(&hour,    1, hour.sizeof,    pfile); // write hour
			fwrite(&minute,  1, minute.sizeof,  pfile); // write minute
			fwrite(&second,  1, second.sizeof,  pfile); // write second
		}
		fwrite(&_displayStartTimeFlag,  1, _displayStartTimeFlag.sizeof,  pfile); // write start tod (time of day) display switch

		with( _endTime ) // end time
			_jDateTime = JDateTime( 1, 1, 1, hour, minute, second );
		with (_jDateTime)
		{
			fwrite(&hour,    1, hour.sizeof,    pfile); // write hour
			fwrite(&minute,  1, minute.sizeof,  pfile); // write minute
			fwrite(&second,  1, second.sizeof,  pfile); // write second
		}
		fwrite(&_displayEndTimeFlag,  1, _displayEndTimeFlag.sizeof,  pfile); // write end tod (time of day) display switch
	}
}
