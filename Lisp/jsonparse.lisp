;;; 885925 Yzeiri Flavio
;;; 887525 Falbo Andrea

;;; -*- Mode: Lisp -*-

;;; jsonparse.lisp
;; Make a lisp library that builds data structures representing JSON objects, 
;; starting from their representation as strings.

;;; split between array and object
(defun jsonparse (JSONString)
  (let ((jsonlist (escape (coerce JSONString 'list))))
       (or (parsearray jsonlist)
           (parseobject jsonlist)
           (error "ERROR: syntax error"))))

;;; remove escape character
(defun escape (string)
  (remove #\Space
    (remove #\Tab
	    (remove #\Return
			  (remove #\NewLine
				  (substitute #\" #\' string))))))

;;; parse array using multiple-value-bind on element
(defun parsearray (arr)
  (if (eql (car arr) #\[)
      (if (eql (car (cdr arr)) #\])
          (values (list 'jsonarray) (cdr (cdr arr)))
          (multiple-value-bind (output morearrays)
            (parseelement (cdr arr))
          (if (eql (car morearrays) #\])
		          (values (cons 'jsonarray output) (cdr morearrays))
		          (error "ERROR: syntax error"))))
      (values nil arr)))

;;; parse object using mulitple-value-bind on member
(defun parseobject (obj)
  (if (eql (car obj) #\{)
      (if (eql (car (cdr obj)) #\})
          (values (list 'jsonobj) (cdr (cdr obj)))
          (multiple-value-bind (output moreobjects)
              (parsemember (cdr obj))
          (if (eql (car moreobjects) #\})
		          (values (cons 'jsonobj output) (cdr moreobjects))
		          (error "ERROR: syntax error"))))
      (values nil obj)))

;;; parse element using multiple-value-bind on value
(defun parseelement (elem)
  (multiple-value-bind (res moreelements)
    (parsevalue elem)
    (if (null res)
        (error "ERROR: syntax error")
	      (if (eql (car moreelements) #\,)
            (multiple-value-bind (first others)
		          (parseelement (cdr moreelements))
              (if (null first)
                  (error "ERROR: syntax error")
		              (values (cons res first) others)))
          (values (cons res nil) moreelements)))))

;;; parse member using multiple-value-bind on pair
(defun parsemember (memb)
  (multiple-value-bind (res moremembers)
    (parsepair memb)
    (if (null res)
        (error "ERROR: syntax error")
	      (if (eql (car moremembers) #\,)
            (multiple-value-bind (first others)
		          (parsemember (cdr moremembers))
              (if (null first)
                  (error "ERROR: syntax error")
		              (values (cons res first) others)))
          (values (cons res nil) moremembers)))))

;;; give the value to the right parse
(defun parsevalue (value)
  (cond ((eql (car value) #\[)
         (parsearray value))
        ((eql (car value) #\{)
         (parseobject value))
        ((or (eql (car value) #\")
             (eql (car value) #\'))
         (parsestring value))
        ((or (eql (car value) #\+)
             (eql (car value) #\-)
             (digit-char-p (car value))) (parsenumber value))
        (T (error "ERROR: syntax error"))))

;;; parse pair using multiple-value-bind on char
(defun parsestring (string)
  (cond ((eql (car string) #\")
         (multiple-value-bind (first others)
            (parsechar (cdr string) (car string))
            (values (coerce first 'string) others)))
        (T (error "ERROR: syntax error"))))

;;; parse number using multiple-value-bind on integer
(defun parsenumber (num)
  (cond ((or (digit-char-p (car num))
             (eql (car num) #\+)
             (eql (car num) #\-))
         (multiple-value-bind (first others)
            (parseinteger (cdr num))
            (values (car (multiple-value-list (read-from-string 
              (coerce (cons (car num) first) 'string)))) others)))
        (T (error "ERROR: syntax error"))))

;;; parse pair using multiple-value-bind on string
(defun parsepair (pair)
  (multiple-value-bind (first others)
    (parsestring pair)
    (if (or (null first)
            (null others))
        (error "ERROR: syntax error")
        (if (eql (car others) #\:)
            (multiple-value-bind (firsto resto)
		        (parsevalue (cdr others))
            (if (null firsto)
                (error "ERROR: syntax error")
		            (values (list first firsto) resto)))
            (error "ERROR: syntax error")))))

;;; parse char using ascii
(defun parsechar (char last)
  (if (eql (car char) last)
      (values nil (cdr char))
      (if (and (<= (char-int (car char)) 128)
               (<= (char-int (car char)) 128))
          (multiple-value-bind (first others)
            (parsechar (cdr char) last)
            (values (cons (car char) first) others))
	        (error "ERROR: syntax error"))))

;;; parse integer using multiple-value-bind on float
(defun parseinteger (integer)
  (if (null (car integer)) nil
      (cond ((and (eql (car integer) #\.)
             (digit-char-p (second integer)))
             (multiple-value-bind (first other_integers)
             (parsefloat (cdr integer))
             (values (cons (car integer) first) other_integers)))
          ((digit-char-p (car integer))
           (multiple-value-bind (first other_integers)
		          (parseinteger (cdr integer))
              (values (cons (car integer) first) other_integers)))
        (T (values nil integer)))))

;;; parse float number
(defun parsefloat (float)
  (if (null (car float)) nil
      (if (digit-char-p (car float))
          (multiple-value-bind (first others)
              (parsefloat (cdr float))
            (values (cons (car float) first) others))
	  (values nil float))))

;;; call access with jsonobj and result
(defun jsonaccess (Jsonobj &rest Result)
  (accessto Jsonobj Result))

;;; split between array and object
(defun accessto (obj result)
  (cond ((null (car result)) obj)
        ((and (stringp (car result))
              (eq (car obj) 'jsonobj))
                (getfield (rest obj) result))
        ((and (numberp (car result))
              (eq (car obj) 'jsonarray))
                (getindex (rest obj) result))
        (T (error "ERROR: Syntax error"))))

;;; get the field of the object
(defun getfield (obj result)
  (cond ((null obj) (error "ERROR: Syntax error"))
        ((string= (car result) (car (car obj)))
         (accessto (second (car obj)) (rest result)))
        (T (getfield (rest obj) result))))

;;; get the index of the array
(defun getindex (obj index)
  (cond ((null obj) (error "ERROR: Syntax error"))
        ((= 0 (car index)) (accessto (car obj) (rest index)))
        (T (getindex (rest obj) 
          (append (list (- (car index) 1)) (rest index))))))

;;; read the file and call readfrom
(defun jsonread (filename)
  (with-open-file (input filename)
                  :direction :input
                  :if-does-not-exist :error
    (let ((jsonstring (coerce (readfrom input) 'string )))
          (jsonparse jsonstring))))

;;;read the file until it ends
(defun readfrom (string)
  (let ((pointer (read-char string nil 'eof)))
    (unless (eql pointer 'eof)
      (cons pointer (readfrom string)))))

;;; json dump
(defun jsondump (JSON filename)
  (with-open-file (scanner filename :direction :output
                                    :if-exists :supersede
                                    :if-does-not-exist :create)
                  (cond ((write-string (dumpto JSON) scanner) filename))))

;;; understand if it is an array or an object
(defun dumpto (value)
  (cond ((eq (car value) 'jsonobj)
          (concatenate 'string "{" (writeobj (rest value)) "}"))
        ((eq (car value) 'jsonarray)
         (concatenate 'string "[" (writearray (rest value)) "]"))
        (T (error "ERROR: syntax error"))))

;;; base and recursive case of object
(defun writeobj (obj)
  (cond ((null obj) "")
        ((not (null (rest obj)))
          (concatenate 'string
          (writefield (car (car obj))) " : "
          (writevalue (car (cdr (car obj)))) ", "
          (writeobj (rest obj))))
        (T (concatenate 'string
          (writefield (car (car obj))) " : "
          (writevalue (car (cdr (car obj))))))))

;;; base and recursive case of array
(defun writearray (obj)
  (cond ((null obj) "")
        ((not (null (rest obj)))
          (concatenate 'string
            (writevalue (car obj)) ", "
            (writearray (rest obj))))
        (T (concatenate 'string
          (writevalue (car obj))))))

;;; write field for object
(defun writefield (field)
  (cond ((stringp field)
         (concatenate 'string (string #\") field (string #\")))
         (T (error "ERROR: syntax error"))))

;;; write value for both
(defun writevalue (value)
  (cond ((listp value) (dumpto value))
        ((stringp value) (writefield value))
        ((numberp value) (write-to-string value))
        ((eq value 'true) (string value))
        ((eq value 'false) (string value))
        ((eq value 'null) (string value))
        (T (error "ERROR: Syntax error"))))

;;    end of file -- jsonparse.lisp --
