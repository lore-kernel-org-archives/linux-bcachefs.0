Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35EFC1
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Nov 2023 23:49:29 -0800 (PST)
Received: from [192.168.1.123] (ip5b4280bd.dynamic.kabel-deutschland.de [91.66.128.189])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: buczek)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id E279F61E5FE01;
	Tue, 28 Nov 2023 08:49:23 +0100 (CET)
Message-ID: <3222cf4b-8f9d-4576-b2e2-c78e5655f4dc@molgen.mpg.de>
Date: Tue, 28 Nov 2023 08:49:23 +0100
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-bcachefs@vger.kernel.org
Cc: Stefan Krueger <stefan.krueger@aei.mpg.de>
From: Donald Buczek <buczek@molgen.mpg.de>
Subject: How to cope with subvolumes and snapshots on muti-user systems?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

I'm happy, bcachefs finally made it to mainline, Kudos to Kent!

As far as I know, there is an ongoing discussion about the problems of non-unique inode numbers exposed by snapshots an no real conclusion yet, on how filesystems should expose snapshots.

The current behavior is kind of a showstopper for us, because we are still running multi-user systems. The problem is, that any unprivileged user can create subvolumes and snapshots:

     buczek@dose:/scratch/local3$ bcachefs subvolume create vol1
     buczek@dose:/scratch/local3$ mkdir vol1/dir1
     buczek@dose:/scratch/local3$ bcachefs subvolume snapshot vol1/snp1
     buczek@dose:/scratch/local3$ ls -li vol1/
     total 0
     1342189197 drwxrwxr-x 2 buczek buczek 0 Nov 20 15:01 dir1
     1476413180 drwxrwxr-x 3 buczek buczek 0 Nov 20 15:01 snp1
     buczek@dose:/scratch/local3$ ls -li vol1/snp1/
     total 0
     1342189197 drwxrwxr-x 2 buczek buczek 0 Nov 20 15:01 dir1
     buczek@dose:/scratch/local3$ find .
     .
     ./vol1
     find: File system loop detected; ‘./vol1/snp1’ is part of the same file system loop as ‘./vol1’.
     ./vol1/dir1
     buczek@dose:/scratch/local3$

We have a few tools which walk over the filesystem (backup, mirror, accounting) and these are just not prepared for non-unique inode numbers aside from regular hardlinks. I'm concerned that experiments of a unprivileged users could make important tools to fail.

Questions:

- Would it be a workaround to make creation of subvolumes and snapshots privileged operations?

- If we want to evolve our tools: What is the best way for userspace to recognize subvolumes and snapshots and tell them apart from ordinary directories?

Thanks

   Donald

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
