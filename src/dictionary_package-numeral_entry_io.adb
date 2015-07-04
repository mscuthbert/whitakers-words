-- WORDS, a Latin dictionary, by Colonel William Whitaker (USAF, Retired)
--
-- Copyright William A. Whitaker (1936–2010)
--
-- This is a free program, which means it is proper to copy it and pass
-- it on to your friends. Consider it a developmental item for which
-- there is no charge. However, just for form, it is Copyrighted
-- (c). Permission is hereby freely given for any and all use of program
-- and data. You can sell it as your own, but at least tell me.
--
-- This version is distributed without obligation, but the developer
-- would appreciate comments and suggestions.
--
-- All parts of the WORDS system, source code and data files, are made freely
-- available to anyone who wishes to use them, for whatever purpose.

separate (Dictionary_Package)
package body Numeral_Entry_IO is
   use Inflections_Package.Integer_IO;

   ---------------------------------------------------------------------------

   Spacer : Character := ' ';

   -- FIXME: Why is this one set here?
   Num_Out_Size : constant := 5; -- NOTE: Set in spec

   ---------------------------------------------------------------------------

   procedure Get (File : in File_Type; Item : out Numeral_Entry) is
   begin
      Decn_Record_IO.Get (File, Item.Decl);
      Get (File, Spacer);
      Numeral_Sort_Type_IO.Get (File, Item.Sort);
      Get (File, Spacer);
      Inflections_Package.Integer_IO.Get (File, Item.Value);
   end Get;

   ---------------------------------------------------------------------------

   procedure Get (Item : out Numeral_Entry) is
   begin
      Decn_Record_IO.Get (Item.Decl);
      Get (Spacer);
      Numeral_Sort_Type_IO.Get (Item.Sort);
      Get (Spacer);
      Get (Item.Value);
   end Get;

   ---------------------------------------------------------------------------

   procedure Put (File : in File_Type; Item : in Numeral_Entry) is
   begin
      Decn_Record_IO.Put (File, Item.Decl);
      Put (File, ' ');
      Numeral_Sort_Type_IO.Put (File, Item.Sort);
      Put (File, ' ');
      Inflections_Package.Integer_IO.Put (File, Item.Value, Num_Out_Size);
   end Put;

   ---------------------------------------------------------------------------

   procedure Put (Item : in Numeral_Entry) is
   begin
      Decn_Record_IO.Put (Item.Decl);
      Put (' ');
      Numeral_Sort_Type_IO.Put (Item.Sort);
      Put (' ');
      Inflections_Package.Integer_IO.Put (Item.Value, Num_Out_Size);
   end Put;

   ---------------------------------------------------------------------------

   procedure Get
      ( Source : in  String;
        Target : out Numeral_Entry;
        Last   : out Integer
      )
   is
      -- Used for computing lower bound of substring
      Low : Integer := Source'First - 1;
   begin
      Decn_Record_IO.Get (Source (Low + 1 .. Source'Last), Target.Decl, Low);
      Low := Low + 1;
      Numeral_Sort_Type_IO.Get
         ( Source (Low + 1 .. Source'Last), Target.Sort, Low );
      Low := Low + 1;
      Inflections_Package.Integer_IO.Get
         ( Source (Low + 1 .. Source'Last), Target.Value, Last );
   end Get;

   ---------------------------------------------------------------------------

   procedure Put (Target : out String; Item : in Numeral_Entry)
   is
      -- These variables are used for computing bounds of substrings
      Low  : Integer := Target'First - 1;
      High : Integer := 0;
   begin
      -- Put Decn_Record
      High := Low + Decn_Record_IO.Default_Width;
      Decn_Record_IO.Put (Target (Low + 1 .. High), Item.Decl);
      Low := High + 1;
      Target (Low) :=  ' ';

      -- Put Numeral_Sort_Type
      High := Low + Numeral_Sort_Type_IO.Default_Width;
      Numeral_Sort_Type_IO.Put (Target (Low + 1 .. High), Item.Sort);
      Low := High + 1;
      Target (Low) :=  ' ';

      -- Put Integer
      -- High := Low + Numeral_Value_Type_IO.Default_Width;
      High := Low + Num_Out_Size;
      Inflections_Package.Integer_IO.Put (Target (Low + 1 .. High), Item.Value);

      -- Fill remainder of string
      Target (High + 1 .. Target'Last) := (others => ' ');
   end Put;

   ---------------------------------------------------------------------------

end Numeral_Entry_IO;