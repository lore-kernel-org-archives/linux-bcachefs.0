Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043441B6525
	for <linux-bcachefs@vger.kernel.org>; Mon,  9 Sep 2024 13:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725889063; cv=none; b=cAkFUM4JWsMS33MOvgx0XBvpioNuBWQkeU/TkmsNsKLUwyVpGb/p/+vm2FemQ4yd9PL/sjFTIboqYmagriHu7TlOHMr6hHDBPWApGEouRGnh24/X2Q90s34ktgVX12etC1x+0oKftJ/nRHen8rvBmKcsDeaXQyQGg91jGv3btso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725889063; c=relaxed/simple;
	bh=gZqZhISgHvZTUzlGUuvFUQr0+DTNWeJvSGNouERHTns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A0AVYSFMKErCCanwsDe9bcXTR1XhS8GH7ZcxcODpQ1xWn8ZjZa2g19O/bsF03z4ZiBICLcF9SCP5J/K+KBSsEfgXMBpbI5yMjUkISP9zPm4URV/uCdsc3mHAQmdscIYUAafzUV/BY9H16xz38tgxRu51LgtoX29Dlz4dEu1nqLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gQi2T54h; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gQi2T54h"
Date: Mon, 9 Sep 2024 09:37:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725889058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3x5d5FNjXCc+dIUGUec8SgcGHm5i1YdUT+AdZhekS/o=;
	b=gQi2T54hyANEtaDU1atk55B1D1bzOfDL1p19yewI+WR0xywQu8eeYAOcNZTPBt8nHpIaGY
	xk0gT6Nw4oWM8g/pDEsTrxaD25nFbNXKJcUH0DZLaAF9WJFVkRnu2MHwpDu5A6aI0FYUet
	DhlqldYD+Qk7lU5XU4+r8ZF1sX2l3qQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: David Wang <00107082@163.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG?] bcachefs performance: read is way too slow when a file
 has no overwrite.
Message-ID: <ebqvaqme76nrgr2dh7avy7yjwxsgnnybxuybgxejahupgbrqw5@a6d244ghjqis>
References: <ka3sjrka6dugdaab2bvewfbonc3ksixumue3hs2juhajhjm37w@bnxvz5mozpgr>
 <20240907103437.71139-1-00107082@163.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240907103437.71139-1-00107082@163.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Sep 07, 2024 at 06:34:37PM GMT, David Wang wrote:
> At 2024-09-07 01:38:11, "Kent Overstreet" <kent.overstreet@linux.dev> wrote:
> >On Fri, Sep 06, 2024 at 11:43:54PM GMT, David Wang wrote:
> >> 
> >> Hi,
> >> 
> >> I notice a very strange performance issue:
> >> When run `fio direct randread` test on a fresh new bcachefs, the performance is very bad:
> >> 	fio --randrepeat=1 --ioengine=libaio --direct=1 --name=test  --bs=4k --iodepth=64 --size=1G --readwrite=randread  --runtime=600 --numjobs=8 --time_based=1
> >> 	...
> >> 	Run status group 0 (all jobs):
> >> 	   READ: bw=87.0MiB/s (91.2MB/s), 239B/s-14.2MiB/s (239B/s-14.9MB/s), io=1485MiB (1557MB), run=15593-17073msec
> >> 
> >> But if the files already exist and have alreay been thoroughly overwritten, the read performance is about 850MB+/s,
> >> almost 10-times better!
> >> 
> >> This means, if I copy some file from somewhere else, and make read access only afterwards, I would get really bad performance.
> >> (I copy files from other filesystem, and run fio read test on those files, the performance is indeed bad.)
> >> Copy some prepared files, and make readonly usage afterwards, this usage scenario is quite normal for lots of apps, I think.
> >
> >That's because checksums are at extent granularity, not block: if you're
> >doing O_DIRECT reads that are smaller than the writes the data was
> >written with, performance will be bad because we have to read the entire
> >extent to verify the checksum.
> 
> 
> >
> >block granular checksums will come at some point, as an optional feature
> >(most of the time you don't want them, and you'd prefer more compact
> >metadata)
> 
> Hi, I made further tests combining different write and read size, the results
> are not confirming the explanation for O_DIRECT.
> 
> Without O_DIRECT (fio  --direct=0....), the average read bandwidth
> is improved, but with a very big standard deviation:
> +--------------------+----------+----------+----------+----------+
> | prepare-write\read |    1k    |    4k    |    8K    |   16K    |
> +--------------------+----------+----------+----------+----------+
> |         1K         | 328MiB/s | 395MiB/s | 465MiB/s |          |
> |         4K         | 193MiB/s | 219MiB/s | 274MiB/s | 392MiB/s |
> |         8K         | 251MiB/s | 280MiB/s | 368MiB/s | 435MiB/s |
> |        16K         | 302MiB/s | 380MiB/s | 464MiB/s | 577MiB/s |
> +--------------------+----------+----------+----------+----------+
> (Rows are write size when preparing the test files, and columns are read size for fio test.)
> 
> And with O_DIRECT, the result is:
> +--------------------+-----------+-----------+----------+----------+
> | prepare-write\read |     1k    |     4k    |    8K    |   16K    |
> +--------------------+-----------+-----------+----------+----------+
> |         1K         | 24.1MiB/s | 96.5MiB/s | 193MiB/s |          |
> |         4K         | 14.4MiB/s | 57.6MiB/s | 116MiB/s | 230MiB/s |
> |         8K         | 24.6MiB/s | 97.6MiB/s | 192MiB/s | 309MiB/s |
> |        16K         | 26.4MiB/s |  104MiB/s | 206MiB/s | 402MiB/s |
> +--------------------+-----------+-----------+----------+----------+
> 
> code to prepare the test files:
> 	#define KN 8 //<- adjust this for each row
> 	char name[32];
> 	char buf[1024*KN];
> 	int main() {
> 		int i, m = 1024*1024/KN, k, df;
> 		for (i=0; i<8; i++) {
> 			sprintf(name, "test.%d.0", i);
> 			fd = open(name, O_CREAT|O_DIRECT|O_SYNC|O_TRUNC|O_WRONLY);
> 			for (k=0; k<m; k++) write(fd, buf, sizeof(buf));
> 			close(fd);
> 		}
> 		return 0;
> 	}
> 
> Based on the result:
> 1. The row with prepare-write size 4K stands out, here.
> When files were prepaired with write size 4K, the afterwards
>  read performance is worse.  (I did double check the result,
> but it is possible that I miss some affecting factors.);

On small blocksize tests you should be looking at IOPS, not MB/s.

Prepare-write size is the column?

Another factor is that we do merge extents (including checksums); so if
the preparet-write is done sequentially we won't actually be ending up
with extents of the same size as what we wrote.

I believe there's a knob somewhere to turn off extent merging (module
parameter? it's intended for debugging).

> 2. Without O_DIRECT, read performance seems correlated with the difference
>  between read size and prepare write size, but with O_DIRECT, correlation is not obvious.

So the O_DIRECT and buffered IO paths are very different (in every
filesystem) - you're looking at very different things. They are both
subject to the checksum granularity issue, but in buffered mode we round
up reads to extent size, when filling into the page cache.

Big standard deviation (high tail latency?) is something we'd want to
track down. There's a bunch of time_stats in sysfs, but they're mostly
for the write paths. If you're trying to identify where the latencies
are coming from, we can look at adding some new time stats to isolate.
