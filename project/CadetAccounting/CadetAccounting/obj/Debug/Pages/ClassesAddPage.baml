   M S B A M L   `   `   `  ����J  FCadetAccounting, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null=#clr-namespace:CadetAccounting.PagesCadetAccounting.Pages  5      *    $CadetAccounting.Pages.ClassesAddPage   5      R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35^ ZWindowsFormsIntegration, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35F 9http://schemas.microsoft.com/winfx/2006/xaml/presentation     5      R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5      Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5      @d2http://schemas.microsoft.com/expression/blend/2008     5      5local#clr-namespace:CadetAccounting.Pages     5        N� Title$  ClassesAddPage��5	      .��5      �  � RowDefinitions 5   
   �� 5      $��* �6   �� 5      $��70 �6   .+�5   
   ��  �� CornerRadius$ 20��6   $��0q�5      ���	#FF65A2CA$��0��5      $	��250��5      $
��0,15q�5      $	��320��5      ._�5      ��  �� Orientation$ Vertical=�6   $	��240��5      $
��0,25q�5      $��Center=�5      $��Center=�5       .+�5"      �� $��Тема занятия��6   $	��200��60   �� 5#      -   5         ��Name$ NameTB��5#      $��18(�6*   $��0q�68   $	��200��5$      ��5%      �� *Name+�� 5'      $��Дата��6   $	��200��6(   $
��0,10q�5(      �� 5)      -   5        $ DateTB��5)      $��18(�6*   $��0q�68   $	��200��5*      ��5+      �� *Date+ �� StringFormat$ 
dd/MM/yyyy���� 5-      $��
Время��6   $	��200��6)   $
��0,10q�5.      �� 5/      -   5        $ TimeTB��5/      $��18(�6*   $��0q�68   $	��200��50      ��51      �� *Time+�� 53      $��№ аудитории��6   $	��200��6/   $
��0,10q�54      �� 55      -   5        $ RoomTB��55      $��18(�6*   $��0q�68   $	��200��56      ��57      �� *
RoomNumber+59      5:      �� 5<   
   $��1��6   ���	#FF579DCA$	��400��5>      $��0,5,0,0q�5?      $ 	20,20,0,0��5@      ._�5B      �� $ 
Horizontal=�6   $��Center=�5C      $��Bottom=�5D      .+�5F      �� -   5         ��Name$ SaveBtn��5F      $��Сохранить��5G      $��
0,10,10,10q�5H      �� 5I      -   5        $ 	CancelBtn��5I      $��Отменить��5J      $��
0,10,10,10q�5K      5M      5P      5R      5S      