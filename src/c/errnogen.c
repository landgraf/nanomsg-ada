#include <stdio.h>
#include <errno.h>
int
main ( void ){
	printf("with Ada.Unchecked_Conversion;\npackage Syserrors is\n");
	printf("type Errno is (ECHILD,EAGAIN,ENOMEM,EACCES,EFAULT,ENOTBLK,EBUSY,EEXIST,EXDEV,ENODEV,ENOTDIR,EISDIR,EINVAL,ENFILE,EMFILE,ENOTTY,ETXTBSY,EFBIG,ENOSPC,ESPIPE,EROFS,EMLINK,EPIPE,EDOM,ERANGE);\n");
	printf("for Errno use (ECHILD =>  %d, EAGAIN =>  %d, ENOMEM =>  %d, EACCES =>  %d, EFAULT =>  %d, ENOTBLK =>  %d, EBUSY =>  %d, EEXIST =>  %d, EXDEV =>  %d, ENODEV =>  %d, ENOTDIR =>  %d, EISDIR =>  %d, EINVAL =>  %d, ENFILE =>  %d, EMFILE =>  %d, ENOTTY =>  %d, ETXTBSY =>  %d, EFBIG =>  %d, ENOSPC =>  %d, ESPIPE =>  %d, EROFS =>  %d, EMLINK =>  %d, EPIPE =>  %d, EDOM =>  %d, ERANGE =>  %d ); \n", ECHILD, EAGAIN, ENOMEM, EACCES, EFAULT, ENOTBLK, EBUSY, EEXIST, EXDEV, ENODEV, ENOTDIR, EISDIR, EINVAL, ENFILE, EMFILE, ENOTTY, ETXTBSY, EFBIG, ENOSPC, ESPIPE, EROFS, EMLINK, EPIPE, EDOM, ERANGE);
        printf("   function Value is new Ada.Unchecked_Conversion(Errno, Integer);\nend Syserrors;\n");
};
