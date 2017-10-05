with Ada.Unchecked_Conversion;
package Syserrors is
type Errno is (ECHILD,EAGAIN,ENOMEM,EACCES,EFAULT,ENOTBLK,EBUSY,EEXIST,EXDEV,ENODEV,ENOTDIR,EISDIR,EINVAL,ENFILE,EMFILE,ENOTTY,ETXTBSY,EFBIG,ENOSPC,ESPIPE,EROFS,EMLINK,EPIPE,EDOM,ERANGE);
for Errno use (ECHILD =>  10, EAGAIN =>  11, ENOMEM =>  12, EACCES =>  13, EFAULT =>  14, ENOTBLK =>  15, EBUSY =>  16, EEXIST =>  17, EXDEV =>  18, ENODEV =>  19, ENOTDIR =>  20, EISDIR =>  21, EINVAL =>  22, ENFILE =>  23, EMFILE =>  24, ENOTTY =>  25, ETXTBSY =>  26, EFBIG =>  27, ENOSPC =>  28, ESPIPE =>  29, EROFS =>  30, EMLINK =>  31, EPIPE =>  32, EDOM =>  33, ERANGE =>  34 ); 
   function Value is new Ada.Unchecked_Conversion(Errno, Integer);
end Syserrors;
