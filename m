Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="u6CVlqh9"
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1599FAD
	for <linux-bcachefs@vger.kernel.org>; Fri, 17 Nov 2023 12:06:48 -0800 (PST)
Date: Fri, 17 Nov 2023 15:06:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700251605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=drqQnY2hsKnY8ZTN81YD5PLnWHjF36L63FC08u26Suc=;
	b=u6CVlqh951hnGL+KG65HRQBRr7/NYKiDMa8lpDgUYQtgFkqTLaGVNBU1v2pFvTMDT0kO3S
	g4an3lt+j1AEvAU4cT27hJbF5EEZgDLKQ6qvFzN6axR3u+ssWn6D6yKoV6USvida2GWKdU
	NMFuFMXXSc98naRx4ql+VmUMpATUCaY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs-tools: fix broken libblkid superblock wipe
Message-ID: <20231117200642.6cuyzgrtmaxm3ejl@moria.home.lan>
References: <20231117131258.9045-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231117131258.9045-1-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 17, 2023 at 08:12:58AM -0500, Brian Foster wrote:
> When playing around with comparing some fstests results on different
> filesystems, I noticed that a 'bcachefs format' of a previously
> btrfs-formatted device still continued to mount as btrfs. The reason
> for this is that the blkid wipe invoked via open_for_format() is not
> working correctly. blkid_do_wipe() depends on the "SBMAGIC[_OFFSET]"
> values to do any work, and the associated superblock magic flag is
> not enabled on the probe.
> 
> Set the probe flags to explicitly enable the values the bcachefs
> code depends on in the probe. This includes the type, label and
> superblock magic information.
> 
> There are also a couple quirks in the libblkid code that might be
> worth noting. One is that the superblock enablement and flag setting
> functions appear hardcoded to return zero, so we just combine the
> error checks. Second, while blkid_do_wipe() can return an error, it
> actually doesn't in the scenario being addressed here because it
> doesn't seem to distinguish between the values being absent because
> nothing was found by the probe or because the values weren't enabled
> in the first place. Regardless, add an error check here in the event
> the wipe does explicitly fail for some unexpected reason.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Nice! Other people have reported this, glad it's fixed :)
