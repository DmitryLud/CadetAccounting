   M S B A M L   `   `   `  ����J  FCadetAccounting, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null=#clr-namespace:CadetAccounting.PagesCadetAccounting.Pages  5      '    !CadetAccounting.Pages.ClassesPage   5      R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35^ ZWindowsFormsIntegration, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35F 9http://schemas.microsoft.com/winfx/2006/xaml/presentation     5      R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5      Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5      @d2http://schemas.microsoft.com/expression/blend/2008     5      5local#clr-namespace:CadetAccounting.Pages     5        N� Title$  ClassesPage��5	      .��5      �  � ColumnDefinitions 5   
   �� 5      $��* �6   �� 5      $	��140 �6    � RowDefinitions 5   
   �� 5      $��* �6   �� 5      $	��100 �6   .+�5   
   &   System.Windows.Controls.DataGrid  -   5          Name$ DG��5         AutoGenerateColumns .  $��10q�5      ���	#FFC4F0FF   Columns 5      0  *System.Windows.Controls.DataGridTextColumn  5      ,  &System.Windows.Controls.DataGridColumn   Header$ Тема занятия��6%      Width5  /System.Windows.Controls.DataGridLengthConverter$ * 5   %   1  +System.Windows.Controls.DataGridBoundColumn   Binding 5   ;   �� *
Class.Name+5   %     5      $ Дата занятия��6%   $ * 5   %    5   ;   �� *
Class.Date+	 �� StringFormat$	 {0:d/MM/yyyy}��5   %     5      $ Время занятия��6%   $ * 5    %    5   <   �� *
Class.Time+5    %     5!      $ Аудитория��6%   $ * 5"   %    5!   8   �� *Class.RoomNumber+5"   %   4  .System.Windows.Controls.DataGridTemplateColumn  5#      $  Преподаватель��6)   $	 240 6@   
   CellTemplate
 5$      �� 5%      .R�5&      ��  �� Orientation$ 
Horizontal=�6)   .+�5'   "   �� 
���   �$��16(�5)   ,   ��5'   ,   �� *Group.Teacher.Surname+5)   ,   �� 5*   "   
���   �$��5,0,5,0q�5,   ,   $��16(�5-   ,   ��5*   ,   �� *Group.Teacher.Name+5-   ,   �� 5.   "   
���   �$��16(�50   ,   ��5.   ,   �� *Group.Teacher.Patronymic+50   ,   51      52      54      56      �� 58   
   $��1��6   $��0��59      $	��220��5:      $	��120��5;      ���	#FF579DCA$��Center=�5=      $��Center=�5>       �� CornerRadius$ 20��5?      ._�5A      �� $��10q�6   $��Center=�5B      .+�5D      �� $��Группа��6   $��0,10,0,0q�5E      �� 5F      -   5         ��Name$ GroupCB��5F      $��90��5G      $��40��5H      $��0,10,0,0q�5I       �� DisplayMemberPath$
 Name��5J      �� 5K      $$��Формат обучения:��6   $��0,10,0,0q�5L      �� 5M      -   5         ��Name$ TypeTB��5M      $��0,10,0,0q�6,   5O      5Q      �� 5S   
   $��1��6   $��2��5T      ���	#FF579DCA$	��660��5V      $��70��5W      $��Bottom=�5X      $��0,5,0,0q�5Y      $ 	20,20,0,0��5Z      ._�5\      �� $ 
Horizontal=�6   $��Center=�5]      $��Bottom=�5^      .+�5`      �� -   5         ��Name$ AddBtn��5`      $��Добавить��5a      $��
0,10,10,10q�5b      �� 5d      -   5        $ EditBtn��5d      $��Изменить��5e      $��
0,10,10,10q�5f      �� 5h      -   5        $ 	ExportBtn��5h      $	��160��5i      $"��Экспортировать��5j      $��
0,10,10,10q�5k      �� 5m      -   5        $ 	CancelBtn��5m      $��
Назад��5n      $��
0,10,10,10q�5o      5q      5t      5v      5w      