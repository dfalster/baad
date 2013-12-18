
perl -i -pi -e 's/\r\n/\n/g' $* 	# change windows line ends to unix
perl -i -pi -e 's/\r/\n/g' $* 		# change oldtsyl mac line endings to unix
