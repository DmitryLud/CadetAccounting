   M S B A M L   `   `   `  ����J  FCadetAccounting, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null=#clr-namespace:CadetAccounting.PagesCadetAccounting.Pages  5      (    "CadetAccounting.Pages.ContractPage   5      R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35^ ZWindowsFormsIntegration, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35F 9http://schemas.microsoft.com/winfx/2006/xaml/presentation     5      R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5      Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5      @d2http://schemas.microsoft.com/expression/blend/2008     5      5local#clr-namespace:CadetAccounting.Pages     5        N� Title$  ContractPage��5	      .��5      �  � RowDefinitions 5   
   �� 5      $��* �6   �� 5      $��70 �6   .+�5   
   ��  �� CornerRadius$ 20��6   $��0q�5      ���	#FF65A2CA$��0��5      $	��250��5      $
��0,15q�5      $	��420��5      ._�5      ��  �� Orientation$ Vertical=�6   $	��240��5      $
��0,25q�5      $��Center=�5      .+�5!      �� -   5         ��Name$ CadetTBlock��5!      $	��200��61   $��Курсант: ��5"      $
��Wrap=�5#      �� 5%      -   5        $ 
DateTBlock��5%      $	��200��60   $��	0,20,0,10q�5&      $��
Дата: ��5'      $
��Wrap=�5(      �� 5*      $'��!Количество этапов��6   $	��200��65   $
��0,10q�5+      �� 5,      -   5         ��Name$ StepCountTB��5,      $��18(�6/   $��0q�6=   $	��200��5-      ��5.      �� *	StepCount+�� 50      $#��Стоимость этапа��6   $	��200��63   $
��0,10q�51      �� 52      -   5        $ StepPriceTB��52      $��18(�6/   $��0q�6=   $	��200��53      ��54      �� *	StepPrice+�� 56      -   5        $ TotalTBlock��56      $	��200��61   $
��0,10q�57      $��
Итог: ��58      $
��Wrap=�59      5;      5<      �� 5>   
   $��1��6   ���	#FF579DCA$	��400��5@      $��0,5,0,0q�5A      $ 	20,20,0,0��5B      ._�5D      �� $ 
Horizontal=�6   $��Center=�5E      $��Bottom=�5F      .+�5H      �� -   5         ��Name$ SaveBtn��5H      $��Сохранить��5I      $��
0,10,10,10q�5J      �� 5K      -   5        $ 	CancelBtn��5K      $��Отменить��5L      $��
0,10,10,10q�5M      5O      5R      5T      5U      