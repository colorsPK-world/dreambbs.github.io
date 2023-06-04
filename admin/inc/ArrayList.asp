<%
        '/******************************
        '������ArrayList
        '���ƣ����������
        '���ڣ�2007-11-6
        '���ߣ���¥����
        '��ַ��www.xilou.net | www.chinaCMS.org
        '������������ĸ��ֲ���
        '��Ȩ��ת����ע������������
        '******************************
        '����޸ģ�2007-11-6
        '�޸Ĵ�����0
        '�޸�˵����
        'Ŀǰ�汾��v1.0
        '******************************/
Class ArrayList
        Private arrList'//�ڲ�����
    Private arrLength'//��¼����ĳ���
    
    Private Sub Class_Initialize()
        arrList=Array()
        arrLength=0
    End Sub
    
    Private Sub Class_Terminate()
        Erase arrList
        End Sub
    
    '//���鳤��,ֻ��
    Public Property Get Length
        Length=arrLength
    End Property
    
    '//ȡ��ĳ��������ֵ
    Public Function GetValue(index)
        On Error Resume Next
        GetValue=arrList(index)
        If Err Then showErr "ArrayList.GetValue()"&Err.Description:Err.Clear:Exit Function
    End Function
    
        '//��������Array����
        Public Function GetArray()
        GetArray=arrList
    End Function
    
    '//����Ԫ��,��ֵ���ӵ�ArrayList�Ľ�β��
    Public Sub Add(v)
            ReDim Preserve arrList(arrLength)
        arrList(arrLength)=v
        arrLength=arrLength+1
    End Sub
    '//���������ӵ�ArrayList�Ľ�β��
    Public Sub AddArray(arr)
        If Not IsArray(arr) Then showErr "������������(arr):ArrayList.AddArray()":Exit Sub
        Dim I,L,J
        On Error Resume Next
            If arrLength = 0 Then '//���ArrayListΪ����ֱ�Ӹ�ֵ
            arrList=arr
            arrLength=arrLength+UBound(arr)+1
        Else
                L=arrLength+UBound(arr)'//�µ����鳤��
            J=0
                ReDim Preserve arrList(L)
            For I = arrLength To L
                arrList(I)=arr(J)
                J=J+1
            Next
            arrLength=arrLength+UBound(arr)+1
        End If
        If Err Then showErr "ArrayList.AddArray()"&Err.Description:Err.Clear:Exit Sub
        
    End Sub
    '//��Ԫ�ز���ArrayList��ָ��index������,ԭ�е�arrList(index)�������Ԫ�ض�������
    Public Sub Insert(index,v)
        Dim I,v2
        If index<arrLength And index>=0 Then
            ReDim Preserve arrList(arrLength)
        arrLength=arrLength+1
        For I = index To arrLength - 1
            v2=arrList(I)'//����ֵ
            arrList(I)=v
            v=v2
        Next
        Else
                showErr "�±�Խ��:ArrayList.Insert()"
        End If
    End Sub
    '//��һ��������뵽ָ����index��
    Public Sub InsertArray(index,arr)
        If index = "" Or Not IsNumeric(index) Then 
            showErr "�Ƿ��Ĳ���:ArrayList.InsertArray()":Exit Sub
        End If
        If index < 0 Or index > arrLength-1 Then
            showErr "�±�Խ��:ArrayList.InsertArray()":Exit Sub
        End If
        If Not IsArray(arr) Then showErr "������������:ArrayList.InsertArray()":Exit Sub
        Dim I,L1,L2,J:J=0
        On Error Resume Next
        L1=UBound(arr)
        L2=arrLength+L1
        ReDim Preserve arrList(L2)
        For I = arrLength -1 To index Step -1
            arrList(I+L1+1)=arrList(I)'//��index֮���ֵ������
        Next
        For I = index To index+L1
            arrList(I)=arr(J)
        J=J+1
        Next
        If Err Then showErr "ArrayList.InsertArray()"&Err.Description:Err.Clear:Exit Sub
        arrLength=arrLength+L1+1'//�µ����鳤��
    End Sub
    '//��������������Ϊindex�Ķ�Ӧֵ
    '//by xilou 39949376
    Public Sub Update(index,v)
        If index = "" Or Not IsNumeric(index) Then 
            showErr "�Ƿ��Ĳ���(index):ArrayList.Update()":Exit Sub
        End If
        If index < 0  Then '����ط��޸���
		'If index < 0 Or index > arrLength-1 Then
            showErr "�±�Խ��1(index):ArrayList.Update()":Exit Sub
        End If
        arrList(index)=v
    End Sub
    
    '//��ArrayList��ɾ����һ��ƥ����,ע���ǵ�һ��,����õ�һ�µ�����
    Public Sub Remove(v)
        Dim I,index
        index = -1 '//��һ��ƥ�������
        For I = 0 To arrLength - 1
            If arrList(I)=v Then index = I : Exit For
        Next
        If index <> -1 Then
            For I = index To arrLength - 2
            arrList(I) = arrList(I+1)'//ֵ��ǰ���
        Next
        ReDim Preserve arrList(arrLength-1)'//��������
        arrLength = arrLength - 1
        End If
    End Sub
    '//�Ƴ�ArrayList��ָ����������Ԫ��,����õ�һ�µ�����
    Public Sub RemoveAt(index)
        If index = "" Or Not IsNumeric(index) Then 
            showErr "�Ƿ��Ĳ���(index):ArrayList.RemoveAt()":Exit Sub
        End If
        If index < 0 Or index > arrLength-1 Then
            showErr "�±�Խ��(index):ArrayList.RemoveAt()":Exit Sub
        End If
        If index > 0 Then
            For I = index To arrLength - 2
            arrList(I) = arrList(I+1)'//ֵ��ǰ���
            Next
            ReDim Preserve arrList(arrLength-1)'//��������
            arrLength = arrLength - 1
        End If
    End Sub
    '//��һ���������Ƴ�������m������n��һ��Ԫ��,����������Ƴ�������
    Public Function Splice(m,n)
        If m = "" Or n = "" Or Not IsNumeric(m) Or Not IsNumeric(n) Then 
            showErr "�Ƿ��Ĳ���(m,n):ArrayList.Splice()":Exit Function
        End If
        If m < 0 Or m > arrLength-1 Or n < 0 Or n > arrLength-1 Then
            showErr "�±�Խ��(m,n):ArrayList.Splice()":Exit Function
        End If
        Dim newArr,x,L,I,J
        newArr=Array()
        If m > n Then x=m:m=n:n=x '//������ֵ
        L=n-m
        ReDim Preserve newArr(L)
        For I = m To n
            newArr(J)=arrList(I)'Ҫ�Ƴ���Ԫ��
        J=J+1
        Next
        '//��n�����Ԫ�ص�ֵ��ǰ
        For I = (n+1) To arrLength -1
            arrList(I-L-1)=arrList(I)
        Next
        arrLength=arrLength-L-1
        ReDim Preserve arrList(arrLength)
        Splice=newArr
    End Function
    '//�������,���齫��Ϊ��,����Length=0
    Public Sub Clear()
        Erase arrList
        arrLength=0
    End Sub
    '//������ ArrayList ��Ԫ�ص�˳��ת
    Public Sub Reverse()
        Dim L,I,J,v
        J=arrLength-1
            If arrLength > 0 Then
            L=Int(arrLength/2)
        For I = 0 To L-1
            v=arrList(I)
            arrList(I)=arrList(J)
            arrList(J)=v
            J=J-1
        Next
        End If
    End Sub
    '//�����ַ���ֵ�����а��������ӵ�һ������������Ԫ�أ�Ԫ����ָ���ķָ����ָ�����
    Public Function Implode(separator)
        Implode=Join(arrList,separator)
    End Function
    '//����ArrayList��m��n��һ������
    Public Function Slice(m,n)
        If m = "" Or n = "" Or Not IsNumeric(m) Or Not IsNumeric(n) Then 
            showErr "�Ƿ��Ĳ���:ArrayList.Slice()":Exit Function
        End If
        If m < 0 Or m > arrLength-1 Or n < 0 Or n > arrLength-1 Then
            showErr "�±�Խ��:ArrayList.Slice()":Exit Function
        End If
        Dim I,J,newArr()
        J=0
        If m<=n Then
            ReDim Preserve newArr(n-m)
        For I = m To n
            newArr(J)=arrList(I)
            J=J+1
        Next
        Else
            ReDim Preserve newArr(m-n)
        For I = n To m
            newArr(J)=arrList(I)
            J=J+1
        Next
        End If
        Slice=newArr
        Erase newArr
    End Function
    
    '//����,����ArrayList��һ��ƥ����Ĵ��㿪ʼ��������û�ҵ�����-1��
    '//by xilou 39949376
    Public Function IndexOf(v)
        Dim I
        For I = 0 To arrLength - 1
        If arrList(I)=v Then IndexOf=I:Exit Function
        Next
        IndexOf=-1
    End Function
    '//����ArrayList�����һ��ƥ����Ĵ��㿪ʼ��������û�ҵ�����-1��
    Public Function LastIndexOf(v)
        Dim I
        If arrLength=0 Then
            LastIndexOf=-1:Exit Function
        Else
            For I = (arrLength-1) To 0 Step -1
            If arrList(I)=v Then LastIndexOf=I:Exit Function
            Next
        End If
        LastIndexOf=-1
    End Function
    
    '//��ʾ����
    Private Sub showErr(errInfo)
        Response.Write "<div id=""ERRORINFO"" style=""font-size:12px;color:#990000;font-family:""������"", Arial"">"
        Response.Write errInfo
        Response.Write "</div>"
        Response.End()
    End Sub
End Class
%>