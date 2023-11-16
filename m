Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jPvRXGqJ"
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E71FB9
	for <linux-bcachefs@vger.kernel.org>; Thu, 16 Nov 2023 13:11:21 -0800 (PST)
Date: Thu, 16 Nov 2023 16:11:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700169079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TIK/gxVmZiThUvBJ1KI4FLWPeTd6Yst/2BZRO+XEUVw=;
	b=jPvRXGqJ3eAXbeDvObsxVSuY6dqb/meOL70A+7ebIJiR5GyNxGqXaMlF26y+j0n9A7SxCY
	MdfFJLLlpPtp7z2uqR00Fbs1hkzTXFLxFxitzviRxMCVoPHecHpsFMUEZAN1onNvjMgCNt
	Hfw383KhlPJSTKQnAIYg1AdX0WNssG0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: preserve device path as device name
Message-ID: <20231116211116.zdbx3y4c6d4pu7bp@moria.home.lan>
References: <20231116171343.699909-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231116171343.699909-1-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 16, 2023 at 12:13:43PM -0500, Brian Foster wrote:
> Various userspace scripts/tools may expect mount entries in
> /proc/mounts to reflect the device path names used to mount the
> associated filesystem. bcachefs seems to normalize the device path
> to the underlying device name based on the block device. This
> confuses tools like fstests when the test devices might be lvm or
> device-mapper based.
> 
> The default behavior for show_vfsmnt() appers to be to use the
> string passed to alloc_vfsmnt(), so tweak bcachefs to copy the path
> at device superblock read time and to display it via
> ->show_devname().
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good - applied
