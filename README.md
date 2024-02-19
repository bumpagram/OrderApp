#  

внутри проекта в папке resourses есть файл "Open Restaurant.app"
это симуляция сервера, куда мы обращаемся через URLSession и гоняем туда-сюда JSON локально на компе. без него работать не будет.
в него включены по умолчанию:
   /categories = массив String для получения списка блюд по категориям
   /menu = здесь массив с самими элементами, которые надо парсить в свифт файлы
   Reset кнопка = сбрасывает на значения элементов по умолчанию, тк вы можете добавить свои
   Start/stop server = включает и отключает эмуляцию бэкэнда, куда мы обращаемся за данными
   
   Для начала работы надо открыть из Finder "Open Restaurant.app", дать все разрешения и нажать Start, а потом в браузере постучаться в  https://localhost:8080/
   Если открылось, то всё ок. Эмуляция бэкэнда работает.
   
   Цель упражнения: составить UI, сетевые запросы, распарсить джейсоны и вывести всё в таблицы. Затем реализовать поведение корзины с заказами. Она должна отправлять заказ пользователя на сервер в виде массива с [Int], где инты = Id поля элементов блюд.
    В отличие от остальных 2х GET запросов она отправит с клиента URLRequest на /order  типа POST.  в ответ от эмулированного сервера вернется response c кодом ответа и data с Int числом. это количество минут на приготовление заказа. 
   
 ---
   // “Simulate State Restoration
To properly test state restoration, launch your app and add an item to your order. Go back to the Home screen in Simulator, then stop the project from running with Xcode. (To give the app time to complete state preservation, you may need to wait a few beats before stopping the project.) Now relaunch your app from Xcode.
”
 ---  
 

