//#.oO|=====================VERSION 5==========================|Oo.
//#note
module jtask.taskmanbb;

//import std.stdio;
import core.stdc.stdio;
import std.string;
import std.file;
import std.stdio;

public import jtask.taskbb;

/++
 + Task Manager - Bare bones
 +/
struct TaskManbb {
private:
	Taskbb[] m_tasksbb;
public:
	@property ref auto tasksbb() {
		return m_tasksbb;
	}

	/// Load tasks that are done
	void saveDoneTasksbb(string filename)
	{
		string tempFileName = filename ~ ".fragment";
		scope (success) {
			if ( exists( filename ) )
				remove(filename);
			rename(tempFileName, filename);
			writeln(filename, " saved.");
		}
		scope (failure) {
			writefln( `Error has occered(sp) processing "%s" - file not saved!`, filename);
			readln;
		}
		FILE* pfile = fopen(toStringz(tempFileName), "wb");
		int ver = 5;
		try
		{
			//1. (int ver)
			//2. (int num of tasks)
			// 2a. (int id)
			fwrite(&ver, 1, ver.sizeof, pfile); // 1) write version
			int numotasks = cast(int)m_tasksbb.length;
			fwrite(&numotasks, 1, ver.sizeof, pfile); // 2) write number of done tasks
			foreach (dt; m_tasksbb) {
				dt.saveTaskPart(pfile);
			}
		}
		catch (FileException fe)
		{
			std.stdio.writeln("Error with ", tempFileName, ": ", fe.toString);
		}
		finally
		{
			fclose(pfile);
		}
	}

	/// Load tasks that are done
	void loadDoneTasksbb(string filename) {
		// if file loaded ok display so
		scope(success) {
//			setTaskIndex = m_tasksbb.length - 1; //#note
			writeln(filename, " loaded.");
			//# set new done tasks
		}
		scope( failure ) {
			writeln( "Some thing went wrong!" );
		}
		// declare file variable
		FILE* pfile = null;
		int version0 = 0; // version, set to zero even though it gets over ridden
		//1. (int ver)
		//2. (int num of tasks)
		// 2a. (int id)
		// 2b. (char num of chars for task string)
		// 2c. (string task string)
		// 2d. (long date and time number)
		// open file as binary //#not try catch
		//pfile = fopen(toStringz(filename), "rb");
		pfile = fopen(filename.toStringz, "rb");
		m_tasksbb.length = 0;
		fread( &version0, 1, version0.sizeof, pfile ); // 1) version
		debug
			{} //mixin(trace("version0"));
		std.stdio.writeln( "version: ", version0 );
		if (version0 == 3)
		{
			//#version 0 stuff goes here
			//add time period ([int])
			//add comment ([int][string])
			try
			{
				int numoftasks; // number of tasks variable
				fread(&numoftasks, 1, numoftasks.sizeof, pfile); // 2) number of tasks
				//mixin(test("numoftasks > 0", "numotasks > 0")); // not even view able (scrolled out of the screen with time length test
				m_tasksbb.length = numoftasks; // set done tasks length
				// load in done tasks
				foreach (i, ref dt; m_tasksbb)
				{
					dt = new Taskbb;
					dt.loadTaskPart( pfile, version0 ); // read task into task object
				} // foreach
			}
			// catch file error, though none will be throwen with C library functons
			catch (FileException fe)
			{
				// print error message
				std.stdio.writeln("Error with ", filename, ": ", fe.toString);
			}
			finally
			{
				// what ever happens call this
				fclose(pfile);
			}
		} // if version 3

		if (version0 == 4)
		{
			//#version 0 stuff goes here
			//add time period ([int])
			//add comment ([int][string])
			try
			{
				//mixin(test(true, "got here"));
				int numoftasks; // number of tasks variable
				fread(&numoftasks, 1, numoftasks.sizeof, pfile); // 2) number of tasks
				//mixin(test("numoftasks > 0", "numotasks > 0")); // not even view able (scrolled out of the screen with time length test
				m_tasksbb.length = numoftasks; // set done tasks length
				// load in done tasks
				foreach (i, ref dt; m_tasksbb)
				{
					dt = new Taskbb;
					dt.loadTaskPart( pfile, version0 ); // read task into task object
				} // foreach
			}
			// catch file error, though none will be throwen with C library functons
			catch (FileException fe)
			{
				// print error message
				std.stdio.writeln("Error with ", filename, ": ", fe.toString);
			}
			finally
			{
				// what ever happens call this
				fclose(pfile);
			}
		} // if version 4
		
		//#.oO|=====================VERSION 5==========================|Oo.
		if (version0 == 5)
		{
			//#version 0 stuff goes here
			//add time period ([int])
			//add comment ([int][string])
			try
			{
				//mixin(test(true, "got here"));
				int numoftasks; // number of tasks variable
				fread(&numoftasks, 1, numoftasks.sizeof, pfile); // 2) number of tasks
				//mixin(test("numoftasks > 0", "numotasks > 0")); // not even view able (scrolled out of the screen with time length test
				m_tasksbb.length = numoftasks; // set done tasks length
				// load in done tasks
				foreach (i, ref dt; m_tasksbb)
				{
					dt = new Taskbb;
					dt.loadTaskPart( pfile, version0 ); // read task into task object
				} // foreach
			}
			// catch file error, though none will be throwen with C library functons
			catch (FileException fe)
			{
				// print error message
				std.stdio.writeln("Error with ", filename, ": ", fe.toString);
			}
			finally
			{
				// what ever happens call this
				fclose(pfile);
			}
		} // if version 5
		
	}
}
