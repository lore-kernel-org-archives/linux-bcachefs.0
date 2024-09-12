Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CCFC18890E;
	Thu, 12 Sep 2024 07:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726127610; cv=none; b=UsiGZ3UNzQ/1PF9ikU5sGWRlgrWucHBTJvkITn3Lg7KvSkS41fldtS1t6CIDWx4sDJpWqyHvvqFvavLU5jH+gkOdEBa3g8f2KUiRIl2LtVUVqisHIp0YMuxABt1R+6vviw/o+syM6Ntj8KIktrteIZFgbt7uAic+GNQFSTLcye8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726127610; c=relaxed/simple;
	bh=/aRQSdSoUzmofDObR818YvbEyGDSFtOn6CKgE8h2F7s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lLuCgVgOFsMg7SmDwLMRobl65kdCZx+0G6Z9agkdxPuUsxKJORcTciIGeTRjp0/oip32fROcP5XL0lljYWfwDuhBVH7TGnEsDJ+Supe2VwLnlckcQWt8zH7RgEhQyBe+ql3EyqhrBxerY3PcDsZ2LA+doiDBYDtg2KvFidvs740=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ezeEtbe5; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ezeEtbe5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=eYuz3
	1bH0CjNUsYyIVrv4KGMsrjrng9lixjsn5eVDEs=; b=ezeEtbe5QSPbVtjZUKK6S
	pi87kq53Yer8lgbooq6mRcLlBb1rfu88WCX1mPtAUuAUzWjGnkuC4zRnsm2ifmYT
	kfVBDyuBSlLkDEB9KMqqgqvXb2XS8cpbiInyQdOQcwmHCkJNpDs2Skyjormjuask
	mvkcqDg+y7IJfgeEyrox8k=
Received: from localhost.localdomain (unknown [111.35.191.143])
	by gzga-smtp-mta-g3-4 (Coremail) with SMTP id _____wD3P7fOneJmyoVFDg--.56236S4;
	Thu, 12 Sep 2024 15:53:02 +0800 (CST)
From: David Wang <00107082@163.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG?] bcachefs performance: read is way too slow when a file has no overwrite.
Date: Thu, 12 Sep 2024 15:52:46 +0800
Message-Id: <20240912075246.5810-1-00107082@163.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <f69544.2e70.191e419e656.Coremail.00107082@163.com>
References: <f69544.2e70.191e419e656.Coremail.00107082@163.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3P7fOneJmyoVFDg--.56236S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7KFy5uF4UXr1ktw1UXFW3Awb_yoW8uF4Upr
	WSgr13Jr1xKrn5Zw4jk3y0gw43Jw1rAF12yFy8try8Zrn8AwnYvFZ5tryrWFWkCrZ7XF1k
	Z3yqk3s5Ja4Fvw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRF38OUUUUU=
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/1tbiqQRYqmVOC1MgYAAAss


Hi, 

> I made some debug, when performance is bad, the conditions
> bvec_iter_sectors(iter) != pick.crc.uncompressed_size and 
> bvec_iter_sectors(iter) != pick.crc.live_size are "almost" always both "true",
> while when performance is good (after "thorough" write), they are only little
> percent (~350 out of 1000000)  to be true.
> 
> And if those conditions are "true", "bounce" would be set and code seems to run
> on a time consuming path.
> 
> I suspect "merely read" could never change those conditions, but "write" can?
> 

More update: 

1. Without a "thorough" write, it seems no matter what the prepare write size is,
crc.compressed_size is always 128 sectors = 64K?
2. With a "thorough" write with 4K block size, crc.compressed_size mostly descreases to 4K,
only a few crc.compressed_size left with 8/12/16/20K...
3. If a 4K-thorough-write followed by 40K-thorough-write, crc.compressed_size then 
increases to 40K, and 4K direct read suffers again....
4. A 40K-through-write followed by 256K-thorough-write, crc.compressed_size only
increase to 64K, I guess 64K is maximum crc.compressed_size.


So I think current conclusion is:
1. The initial crc.compressed_size is always 64K when file was created/prepared.
2. Afterward writes can change crc size based on write size. (optimized for write?)
3. Direct read performance is sensitive to this crc size, more test result:
	+-----------+--------+----------+
	| rand read |  IOPS  |    BW    |
	+-----------+--------+----------+
	|   4K !E   | 24.7K  | 101MB/s  |
	|   16K !E  | 24.7K  | 404MB/s  |
	|   64K !E  | 24.7K  | 1617MB/s |
	|    4K E   | ~220K  | ~900MB/s |
	|   16K E   |  ~55K  | ~900MB/s |
	|   64K E   | ~13.8K | ~900MB/s |
	+-----------+--------+----------+
E stands for the event that a "thorough" 4k write happened before the test.
Or put it more specific:
E: lots of rand 4k-write, crc.compressed_size = 4K
!E: file was just created, crc.compressed_size = 64K


The behavior seems reasonable from write's point of view, but for read it
dose not sounds good....If a mmaped readonly file, page in less than
16 pages, those extra data would waste lots of disk bandwidth.


David

