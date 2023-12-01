Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Fk9NRrHv"
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [IPv6:2001:41d0:203:375::bb])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886C8171B
	for <linux-bcachefs@vger.kernel.org>; Thu, 30 Nov 2023 19:25:53 -0800 (PST)
Date: Thu, 30 Nov 2023 22:25:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701401151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KcIwmkVle1BFRdCzB9OoiEvV9FDIuec9CunjLP5dT+o=;
	b=Fk9NRrHvrUoGYVDw0vsv12xG82JcG4RVI/3dbYPYq9ZNJU7XdTKRlxZsSbjCIHmpNB9127
	O4KfQbXt+9EQrwPAPoEO3UTpxiwqucXTqzpdzWd1XSmd6mjQ4HRYptyVOHgwUNrUum76Vs
	rcFxZgEGLyNZDRiSQMJa9BO6UbzhSMs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Daniel J Blueman <daniel@quora.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs page fault oops after device evacuate/remove and unmount
Message-ID: <20231201032548.5y3lafkwamlhruqs@moria.home.lan>
References: <CAMVG2stxMYZbDoAHeVQjgJ7f+Td7+VJrLNRbY8au68ZVkzhb0g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMVG2stxMYZbDoAHeVQjgJ7f+Td7+VJrLNRbY8au68ZVkzhb0g@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 30, 2023 at 08:47:33PM -0500, Daniel J Blueman wrote:
> Hi Kent et al,
> 
> On upstream bcachefs (master @ evilpiepirate.org/git/bcachefs.git) SHA
> f8a1ba26, I was able to develop a minimal reproducer [1] for a page
> not present oops I can provoke [2]. It appears we need further
> synchronisation during unmount.
> 
> Let me know when there is a patch I can test, or for debug.
> 
> Thanks,
>   Dan
> 
> -- [1]
> 
> modprobe brd rd_size=536870912 rd_nr=2
> bcachefs format -f /dev/ram0 /dev/ram1
> mount -t bcachefs /dev/ram0:/dev/ram1 /mnt
> fio --group_reporting --ioengine=io_uring --directory=/mnt --size=16m
> --time_based --runtime=60s --iodepth=256 --verify_async=8 --bs=4k-64k
> --norandommap --random_distribution=zipf:0.5 --numjobs=16 --rw=randrw
> --name=A --direct=1 --name=B --direct=0 >/dev/null &
> bcachefs device evacuate /dev/ram0
> bcachefs device remove --force --force-metadata /dev/ram1
> bcachefs device remove --force --force-metadata /dev/ram1
> kill %1
> wait
> umount /mnt

The remove fails for me with DEVICE_SET_STATE_NOT_ALLOWED - evacuate set
ram0 to ro, we can't remove our last rw dev.

Is there a typo there?
