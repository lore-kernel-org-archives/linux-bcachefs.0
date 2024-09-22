Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2653D11712;
	Sun, 22 Sep 2024 08:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726993946; cv=none; b=Blr8UiAB+quxALyA1FRp17xZ2jajq4Ui6eKVmET40LnnBqFjiZHJLVzfk51CwbAF3tVG+xjwSw7LUmou40RLcNRh5baMKk1YXWa1+4kmjx/SiMM1Vzx+HHi7swyZi4Lp7HjIniy2FMmnl5V5Jt2WAGSbD13kNsA/UZwkr6E4i0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726993946; c=relaxed/simple;
	bh=oL+f5U7YY9hatXIInWS9SLc68gfI4L7TBW7ym0eTR/g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tg/RsR+Mozdllc66M4C8vtZrlupYGKss5ySYeQxo4s2FJJSzA8+GAV/QGXmZS+tSl8pojWNXYCR2wuZF+czlZ37BJinl9kZyQy35Yl9TkVNPHDuabeuB+O2/dhToyr5JE4YWr5TSsQbjZmKGCei8CHnqvlTxwE+1qrGl3PvzMAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=JBNsHMf9; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="JBNsHMf9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=zlY7L
	q1dnJyZFIkSt+8e9U8ixq0ZLA70ykIaPVGE5D4=; b=JBNsHMf94WVconweA9u93
	L/3K4MwHae2BWC5UmGaSdyb0171ZFwgwwG481UNBm8i4unrK3aIYZcMTOFbuXtZS
	l7FVThYuwQOAUnvXqWNMn9aA0XfS/teqUd8pGVZY9kuoWhQhJFZ1ZiO/eVg57JJ2
	4nVvlx2Y2ucs2atzNcwnGU=
Received: from localhost.localdomain (unknown [111.35.191.143])
	by gzga-smtp-mta-g3-5 (Coremail) with SMTP id _____wBXrQj11e9mUA8cOQ--.26753S4;
	Sun, 22 Sep 2024 16:32:07 +0800 (CST)
From: David Wang <00107082@163.com>
To: 00107082@163.com,
	kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG?] bcachefs performance: read is way too slow when a file has no overwrite
Date: Sun, 22 Sep 2024 16:31:48 +0800
Message-Id: <20240922083148.10070-1-00107082@163.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <79f17c7a.65f.19217621c47.Coremail.00107082@163.com>
References: <79f17c7a.65f.19217621c47.Coremail.00107082@163.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBXrQj11e9mUA8cOQ--.26753S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxCr4kZrykCr18Zr45ZFWkZwb_yoWrurWxpF
	ySkF12vr98JryUCwnrta1UKa1FvrWrAry3Xrn8G3y0grn8ury3tF1jqrWF9a97Cr93KF4j
	q3yYq34xGwn5JFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUfl1DUUUUU=
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/1tbiMxViqmbvz7duPgAAsP

>Hi, 
>
>At 2024-09-22 00:12:01, "Kent Overstreet" <kent.overstreet@linux.dev> wrote:
>>On Sun, Sep 22, 2024 at 12:02:07AM GMT, David Wang wrote:
>>> Hi, 
>>> 
>>> At 2024-09-09 21:37:35, "Kent Overstreet" <kent.overstreet@linux.dev> wrote:
>>> >On Sat, Sep 07, 2024 at 06:34:37PM GMT, David Wang wrote:
>>> 
>>> >
>>> >Big standard deviation (high tail latency?) is something we'd want to
>>> >track down. There's a bunch of time_stats in sysfs, but they're mostly
>>> >for the write paths. If you're trying to identify where the latencies
>>> >are coming from, we can look at adding some new time stats to isolate.
>>> 
>>> About performance, I have a theory based on some observation I made recently:
>>> When user space app make a 4k(8 sectors) direct write, 
>>> bcachefs would initiate a write request of ~11 sectors, including the checksum data, right?
>>> This may not be a good offset+size pattern of block layer for performance.  
>>> (I did get a very-very bad performance on ext4 if write with 5K size.)
>>
>>The checksum isn't inline with the data, it's stored with the pointer -
>>so if you're seeing 11 sector writes, something really odd is going
>>on...
>>
>
>.... This is really contradict with my observation:
>1. fio stats yields a average 50K IOPS for a 400 seconds random direct write test.
>2. from /proc/diskstatas, average "Field 5 -- # of writes completed"  per second is also 50K
>(Here I conclude the performance issue is not caused by extra IOPS for checksum.)
>3.  from "Field 10 -- # of milliseconds spent doing I/Os",  average disk "busy" time per second is about ~0.9second, similar to the result of ext4 test.
>(Here I conclude the performance issue it not caused by not pushing disk device too hard.)
>4. delta(Field 7 -- # of sectors written) / delta(Field 5 -- # of writes completed)  for 5 minutes interval is 11 sectors/write.
>(This is why I draw the theory that the checksum is with raw data......I thought is was a reasonable...)
>
>I will make some debug code to collect sector number patterns.
>

I collected sector numbers at the beginning of submit_bio in block/blk-core.c,
It turns out my guess was totally wrong, the user data is 8-sectors clean, the ~11 sectors
I observed was just average sector per write. Sorry, I assumed too much, I thought each user write
would be companied by a checksum-write.....
And during a stress direct-4K-write test, the top-20 write sector number pattern is:
	+---------+------------+
	| sectors | percentage |
	+---------+------------+
	|    8    |  97.637%   |
	|    1    |   0.813%   |   
	|   510   |   0.315%   |  <== large <--journal_write_submit
	|    4    |   0.123%   |
	|    3    |   0.118%   |
	|    2    |   0.117%   |
	|   508   |   0.113%   |  <==
	|   509   |   0.094%   |  <==
	|    5    |   0.075%   |
	|    6    |   0.037%   |
	|   507   |   0.032%   |  <==
	|    14   |   0.024%   |
	|    13   |   0.020%   |
	|    11   |   0.020%   |
	|    15   |   0.020%   |
	|    10   |   0.020%   |
	|    16   |   0.018%   |
	|    12   |   0.018%   |
	|    7    |   0.017%   |
	|    20   |   0.017%   |
	+---------+------------+

btree_io write pattern, collected from btree_node_write_endio, 
is kind of uniform/flat distributed, not on block-friendly size
boundaries (I think):
	+---------+------------+
	| sectors | percentage |
	+---------+------------+
	|    1    |   9.021%   |
	|    3    |   1.440%   |
	|    4    |   1.249%   |
	|    2    |   1.157%   |
	|    5    |   0.804%   |
	|    6    |   0.409%   |
	|    14   |   0.259%   |
	|    15   |   0.253%   |
	|    16   |   0.228%   |
	|    7    |   0.226%   |
	|    11   |   0.223%   |
	|    10   |   0.223%   |
	|    13   |   0.222%   |
	|    9    |   0.213%   |
	|    12   |   0.202%   |
	|    41   |   0.194%   |
	|    17   |   0.183%   |
	|    8    |   0.182%   |
	|    18   |   0.167%   |
	|    20   |   0.167%   |
	|    19   |   0.163%   |
	|    21   |   0.160%   |
	|   205   |   0.158%   |
	|    22   |   0.145%   |
	|    23   |   0.117%   |
	|    24   |   0.093%   |
	|    51   |   0.089%   |
	|    25   |   0.080%   |
	|   204   |   0.079%   |
	+---------+------------+


Now, it seems to be that journal_io's big trunk of IO and btree_io's
irregular IO size would be the main causing factors for halving direct-4K-write
 user-io bandwidth, compared with ext4.


Maybe btree_io's irregular IO size could be regularized?

> 
>
>
>>I would suggest doing some testing with data checksums off first, to
>>isolate the issue; then it sounds like that IO pattern needs to be
>>looked at.
>
>I will try it. 

I format  partition with
`sudo bcachefs format --metadata_checksum=none --data_checksum=none /dev/nvme0n1p1`

It dosen't have significant help with write performance:
"IOPS=53.3k, BW=208MiB/s" --> "IOPS=55.3k, BW=216MiB/s",
and btree write's irregular IO size pattern still shows up.

But it help improve direct-4k-read performance significantly, I guess that would be expected
considering no extra data needs to be fetched for each read.

> 
>>
>>Check the extents btree in debugfs as well, to make sure the extents are
>>getting written out as you think they are.


Thanks
David

