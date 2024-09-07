Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E9713D0A9;
	Sat,  7 Sep 2024 10:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725705321; cv=none; b=IiScl0kNiWMfyITyQ+/ndJ62oHbwfxZyX3SWbLVi3IuJ/0NwfBu7Y1WtYUjyaQBfgLAmr6+f/FO6Ov7QgNP6Bg9wVz4i+WFwskAQgW2rHgXZb9J6QXEXfCcpK+Zi8zIdrkMh5xvhmGY5IAHP71VjvLLk5fMPKvQIjVG69OchVH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725705321; c=relaxed/simple;
	bh=fStTyIXrXS6LxZ3OfDuTGxq3cQrSD60MHobAr22TQSM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W6hW2Ac3plwU13BF1nfTtsybE44dsCaJvjJDG1lDqeIslUdJrHmS6oCXRQrWn5wKMrn0v1T7T8V85ZfDuw4KHaUdjpTWDO19yF0WRawWjVsMRLjDT9j//VnW1Ao63Vddc3gudRGVjGhXBr9Pm2/wNpB1DYYF42/DAk+5m6D7vi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=nplw0cc+; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="nplw0cc+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=EylXd
	0u/HEKVMslUIcbQfRlcGaWZZaHFbPx9fuLDqyg=; b=nplw0cc+Zr56K8QR54+Az
	QVMSP2P+41V4qEWQ5kt2teWThqE4jIBF5qbFUnPICypxhtjdJhbFpmCSkIzoHZyL
	zyhWOscHDFsVn/KRLG3UWvtqaezZb2tAGYLLMMxjWdXn/CkMBuG4DP+9Rx4rUdJx
	fi9FMTdWN/A26YofRZlB1s=
Received: from localhost.localdomain (unknown [111.35.190.113])
	by gzga-smtp-mta-g2-1 (Coremail) with SMTP id _____wDnF7c9LNxmaUrfEg--.45805S4;
	Sat, 07 Sep 2024 18:34:51 +0800 (CST)
From: David Wang <00107082@163.com>
To: kent.overstreet@linux.dev
Cc: 00107082@163.com,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG?] bcachefs performance: read is way too slow when a file has no overwrite.
Date: Sat,  7 Sep 2024 18:34:37 +0800
Message-Id: <20240907103437.71139-1-00107082@163.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <ka3sjrka6dugdaab2bvewfbonc3ksixumue3hs2juhajhjm37w@bnxvz5mozpgr>
References: <ka3sjrka6dugdaab2bvewfbonc3ksixumue3hs2juhajhjm37w@bnxvz5mozpgr>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnF7c9LNxmaUrfEg--.45805S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxZr13JFWxKw17Kw1kXF4DXFb_yoWrZF4kpr
	ySyF13JFnrJr15CwsrAw4UtF18Jr1rJwnxJFyUtry8WF15Cry5tayUJFZ5KrWUGryxJr1U
	JFZYqw17try8Xw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUfl1DUUUUU=
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/1tbiqQ5TqmVOCuEPwwAAsS

At 2024-09-07 01:38:11, "Kent Overstreet" <kent.overstreet@linux.dev> wrote:
>On Fri, Sep 06, 2024 at 11:43:54PM GMT, David Wang wrote:
>> 
>> Hi,
>> 
>> I notice a very strange performance issue:
>> When run `fio direct randread` test on a fresh new bcachefs, the performance is very bad:
>> 	fio --randrepeat=1 --ioengine=libaio --direct=1 --name=test  --bs=4k --iodepth=64 --size=1G --readwrite=randread  --runtime=600 --numjobs=8 --time_based=1
>> 	...
>> 	Run status group 0 (all jobs):
>> 	   READ: bw=87.0MiB/s (91.2MB/s), 239B/s-14.2MiB/s (239B/s-14.9MB/s), io=1485MiB (1557MB), run=15593-17073msec
>> 
>> But if the files already exist and have alreay been thoroughly overwritten, the read performance is about 850MB+/s,
>> almost 10-times better!
>> 
>> This means, if I copy some file from somewhere else, and make read access only afterwards, I would get really bad performance.
>> (I copy files from other filesystem, and run fio read test on those files, the performance is indeed bad.)
>> Copy some prepared files, and make readonly usage afterwards, this usage scenario is quite normal for lots of apps, I think.
>
>That's because checksums are at extent granularity, not block: if you're
>doing O_DIRECT reads that are smaller than the writes the data was
>written with, performance will be bad because we have to read the entire
>extent to verify the checksum.


>
>block granular checksums will come at some point, as an optional feature
>(most of the time you don't want them, and you'd prefer more compact
>metadata)

Hi, I made further tests combining different write and read size, the results
are not confirming the explanation for O_DIRECT.

Without O_DIRECT (fio  --direct=0....), the average read bandwidth
is improved, but with a very big standard deviation:
+--------------------+----------+----------+----------+----------+
| prepare-write\read |    1k    |    4k    |    8K    |   16K    |
+--------------------+----------+----------+----------+----------+
|         1K         | 328MiB/s | 395MiB/s | 465MiB/s |          |
|         4K         | 193MiB/s | 219MiB/s | 274MiB/s | 392MiB/s |
|         8K         | 251MiB/s | 280MiB/s | 368MiB/s | 435MiB/s |
|        16K         | 302MiB/s | 380MiB/s | 464MiB/s | 577MiB/s |
+--------------------+----------+----------+----------+----------+
(Rows are write size when preparing the test files, and columns are read size for fio test.)

And with O_DIRECT, the result is:
+--------------------+-----------+-----------+----------+----------+
| prepare-write\read |     1k    |     4k    |    8K    |   16K    |
+--------------------+-----------+-----------+----------+----------+
|         1K         | 24.1MiB/s | 96.5MiB/s | 193MiB/s |          |
|         4K         | 14.4MiB/s | 57.6MiB/s | 116MiB/s | 230MiB/s |
|         8K         | 24.6MiB/s | 97.6MiB/s | 192MiB/s | 309MiB/s |
|        16K         | 26.4MiB/s |  104MiB/s | 206MiB/s | 402MiB/s |
+--------------------+-----------+-----------+----------+----------+

code to prepare the test files:
	#define KN 8 //<- adjust this for each row
	char name[32];
	char buf[1024*KN];
	int main() {
		int i, m = 1024*1024/KN, k, df;
		for (i=0; i<8; i++) {
			sprintf(name, "test.%d.0", i);
			fd = open(name, O_CREAT|O_DIRECT|O_SYNC|O_TRUNC|O_WRONLY);
			for (k=0; k<m; k++) write(fd, buf, sizeof(buf));
			close(fd);
		}
		return 0;
	}

Based on the result:
1. The row with prepare-write size 4K stands out, here.
When files were prepaired with write size 4K, the afterwards
 read performance is worse.  (I did double check the result,
but it is possible that I miss some affecting factors.);
2. Without O_DIRECT, read performance seems correlated with the difference
 between read size and prepare write size, but with O_DIRECT, correlation is not obvious.

And, to mention it again, if I overwrite the files **thoroughly** with fio write test
(using same size), the read performance afterwards would be very good:

	# overwrite the files with randwrite, block size 8k
	$ fio --randrepeat=1 --ioengine=libaio --direct=1 --name=test  --bs=8k --iodepth=64 --size=1G --readwrite=randwrite  --runtime=300 --numjobs=8 --time_based=1
	# test the read performance with randread, block size 8k
	$ fio --randrepeat=1 --ioengine=libaio --direct=1 --name=test  --bs=8k --iodepth=64 --size=1G --readwrite=randread  --runtime=300 --numjobs=8 --time_based=1
	...
	Run status group 0 (all jobs):
	   READ: bw=964MiB/s (1011MB/s), 116MiB/s-123MiB/s (121MB/s-129MB/s), io=283GiB (303GB), run=300004-300005msec



FYI
David

