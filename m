Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD58D23A4
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Dec 2023 01:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JFVuc40+"
Date: Thu, 28 Dec 2023 20:38:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1703813888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=15Di58a8mwv80CnXBsOTa+gg2hKhj7xH1vOy8/wfLC4=;
	b=JFVuc40+1HdEAadYLNs2o7Nvzs2wCkUhW09yERPc0xK1A3cH0BaOsFH+yr9w3UCsZ9HW0y
	eDGEJ82ApPF9/Ttn+vxIiK0Ue0u1GWdfoxdFNX9lS/R7cXM2UyknrKde77R6KFI2JacdDk
	n/o/IuVfoS2NG5h9MMDWMMcS0LKIZl4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: bcachefs subvols / snapshots broken
Message-ID: <vvwnfhsza5ztknnugwgzwyzduaw4uj4wff3ibhr3etpuphojfm@s4wq6fv4322o>
References: <1804957404.243.1703798376220@mail.carlthompson.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1804957404.243.1703798376220@mail.carlthompson.net>
X-Migadu-Flow: FLOW_OUT

On Thu, Dec 28, 2023 at 01:19:36PM -0800, Carl E. Thompson wrote:
> Hello, there appears to be a bug in bcachefs in which certain changes to subvolumes and snapshots can result in file contents not being read properly when copied. Specifically, if a snapshot is created of a subvolume and a file in either the subvolume or the snapshot is removed or modified, incorrect data is read from the corresponding unmodified file in the subvolume or snapshot if that corresponding file is copied. I've reproduced on multiple systems running rc6 and rc7 but on my systems I can reproduce this 100% of the time on bcachefs filesystems where the block size is 4k; I cannot reproduce at all on filesystems with 512 byte blocks (but see below). I've only tested with 4k and 512 block sizes. None of the other format options I've tried made a difference in my tests including compression and bucket size.
> 
> Here is a short example:
> ---
> [carl@clip test]$ bcachefs subvolume create subvol
> 
> [carl@clip test]$ echo "Test" > subvol/file
> 
> [carl@clip test]$ bcachefs subvolume snapshot subvol snapshot_of_subvol
> 
> [carl@clip test]$ rm subvol/file 
> 
> [carl@clip test]$ cat snapshot_of_subvol/file 
> Test
> 
> [carl@clip test]$ cp snapshot_of_subvol/file file
> 
> [carl@clip test]$ cat file
> 
> [carl@clip test]$ ls -l file
> -rw-r--r-- 1 carl carl 5 Dec 28 12:56 file
> 
> [carl@clip test]$ hexdump -C file
> 00000000  00 00 00 00 00                                    |.....|
> 00000005
> 
> [carl@clip test]$ 
> ---
> 
> - The copied file has the correct length but has zeroes instead of the correct data
> - The problem also occurs if the file in the **snapshot** is removed or modified and the original file in the subvolume is copied
> - In my tests I only see the problem on filesystems with 4k blocks. I've never been able to reproduce with 512 byte blocks. However someone else on Reddit says that it definitely happened to them on a filesystem with 512 byte blocks (but they can't reproduce it now)
> - The bug only happens if the file is copied to the same bcachefs filesystem. It does **not** happen if the file is copied to a different bcachefs filesystem or a different filesystem entirely
> - The bug does **not** occur if the cp command is given the `--reflink=never` option
> - Discussion can be found on this Reddit thread (but not all comments are correct: https://www.reddit.com/r/bcachefs/comments/18sbl9z/how_do_you_restore_a_file_from_a_snapshot/
> 
> In my opinion this is a severe issue because it could lead to data loss if users rely on copied files having the correct contents.

Curiously, I'm not able to reproduce it so far with your test - but when
I test with a larger file, everything after a certain point is all
zeroes.

Investigating further...
