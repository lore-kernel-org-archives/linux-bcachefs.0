Received: from smtp.carlthompson.net (charon.carlthompson.net [45.77.7.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F0B107BA
	for <linux-bcachefs@vger.kernel.org>; Thu, 28 Dec 2023 21:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlthompson.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlthompson.net
Received: from mail.carlthompson.net (mail.home [10.35.20.252])
	(Authenticated sender: cet@carlthompson.net)
	by smtp.carlthompson.net (Postfix) with ESMTPSA id 6996714006409
	for <linux-bcachefs@vger.kernel.org>; Thu, 28 Dec 2023 13:19:36 -0800 (PST)
Date: Thu, 28 Dec 2023 13:19:36 -0800 (PST)
From: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
To: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Message-ID: <1804957404.243.1703798376220@mail.carlthompson.net>
Subject: bcachefs subvols / snapshots broken
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.6-Rev53
X-Originating-Client: open-xchange-appsuite

Hello, there appears to be a bug in bcachefs in which certain changes to subvolumes and snapshots can result in file contents not being read properly when copied. Specifically, if a snapshot is created of a subvolume and a file in either the subvolume or the snapshot is removed or modified, incorrect data is read from the corresponding unmodified file in the subvolume or snapshot if that corresponding file is copied. I've reproduced on multiple systems running rc6 and rc7 but on my systems I can reproduce this 100% of the time on bcachefs filesystems where the block size is 4k; I cannot reproduce at all on filesystems with 512 byte blocks (but see below). I've only tested with 4k and 512 block sizes. None of the other format options I've tried made a difference in my tests including compression and bucket size.

Here is a short example:
---
[carl@clip test]$ bcachefs subvolume create subvol

[carl@clip test]$ echo "Test" > subvol/file

[carl@clip test]$ bcachefs subvolume snapshot subvol snapshot_of_subvol

[carl@clip test]$ rm subvol/file 

[carl@clip test]$ cat snapshot_of_subvol/file 
Test

[carl@clip test]$ cp snapshot_of_subvol/file file

[carl@clip test]$ cat file

[carl@clip test]$ ls -l file
-rw-r--r-- 1 carl carl 5 Dec 28 12:56 file

[carl@clip test]$ hexdump -C file
00000000  00 00 00 00 00                                    |.....|
00000005

[carl@clip test]$ 
---

- The copied file has the correct length but has zeroes instead of the correct data
- The problem also occurs if the file in the **snapshot** is removed or modified and the original file in the subvolume is copied
- In my tests I only see the problem on filesystems with 4k blocks. I've never been able to reproduce with 512 byte blocks. However someone else on Reddit says that it definitely happened to them on a filesystem with 512 byte blocks (but they can't reproduce it now)
- The bug only happens if the file is copied to the same bcachefs filesystem. It does **not** happen if the file is copied to a different bcachefs filesystem or a different filesystem entirely
- The bug does **not** occur if the cp command is given the `--reflink=never` option
- Discussion can be found on this Reddit thread (but not all comments are correct: https://www.reddit.com/r/bcachefs/comments/18sbl9z/how_do_you_restore_a_file_from_a_snapshot/

In my opinion this is a severe issue because it could lead to data loss if users rely on copied files having the correct contents.

Thank you,
Carl Thompson
