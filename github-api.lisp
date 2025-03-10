(in-package :cl)
(defpackage github-api
  (:use :cl)
  (:export :get-response
	   :parse-response
	   :print-results
	   :main))

(in-package :github-api)


(defparameter *github-uri* "https://api.github.com/users/")

(function-cache:defcached get-response (username)
  "Send a GET request to github api and return the answer"
  (dex:get (concatenate 'string *github-uri* username)))

(defun parse-response (response)
  "Parse the response received with GET method"
  (jojo:parse response))

(defun print-results (parsed-response &optional (fields '(:|name| :|email| :|location| :|blog| :|twitter_username| :|bio| :|company| :|public_repos| :|created_at| :|updated_at|)))
  "Print the results of the API in a beautiful way"
  (let ((setf (getf parsed-response :|created_at|) ))
  (map 'nil #'(lambda (key) (format t "~A~10T~A~&" key (getf parsed-response key))) fields)))


(defun main ()
  "runs the github-api function in a username passed through cli"
  (let ((args (uiop:command-line-arguments)))
    (print-results
    (parse-response
    (get-response (first args))))))
