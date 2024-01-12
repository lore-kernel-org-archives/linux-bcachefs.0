Received: from mail-108-mta57.mxroute.com (mail-108-mta57.mxroute.com [136.175.108.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2275B22078
	for <linux-bcachefs@vger.kernel.org>; Fri, 12 Jan 2024 13:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="F57URQyR"
Received: from filter006.mxroute.com ([136.175.111.2] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta57.mxroute.com (ZoneMTA) with ESMTPSA id 18cfde1abf30003727.00e
 for <linux-bcachefs@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Fri, 12 Jan 2024 13:34:34 +0000
X-Zone-Loop: b3a4bcd50cd63cd744500e2a3d523bd2097450dcc468
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:In-reply-to:Date:Subject:Cc:To:
	From:References:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=w063HSJyW1ImjwCr5PeZnn5DHNc2eDTl35iwzvMc8iU=; b=F57URQyRqOhdnflP2xaEA5e49y
	zrHK94RafbXZBNnGBh6LeplVvACf33wxkghqswER47SEwLM03rvvMEcBTwU4USCFL81zjvOebIaRv
	SGj1lHmtdiwdjgYPEmFg0bRSzu7pUc8mIPjHmNic7SQB9QDSnBwOqeRPzmNZqQUTVVINps6A9ee7J
	fm35yXrJUhHT1XUAFIPm5M7/N3xRc0memS0giQ/p01bmOBInQIHcG9G5kul+B7qcAGUmpmYnjRVlk
	+gW8iQkPV+8f+CBAnw3Y9+G/0SWlfJNryqnLGb71dmvdT6o5SWvjFqaM9EtPCQWPT935nI2o8xaGn
	dbBZT0IA==;
References: <20231207194011.273027-1-pvorel@suse.cz>
 <20231207194011.273027-2-pvorel@suse.cz>
User-agent: mu4e 1.7.5; emacs 28.2
From: Su Yue <l@damenly.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: ltp@lists.linux.it, Cyril Hrubis <chrubis@suse.cz>, Li Wang
 <liwang@redhat.com>, Richard Palethorpe <rpalethorpe@suse.com>, Jan
 Stancek <jstancek@redhat.com>, Xiao Yang <yangx.jy@fujitsu.com>, Yang Xu
 <xuyang2018.jy@fujitsu.com>, Kent Overstreet <kent.overstreet@linux.dev>,
 Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
 fstests@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, Jan Kara
 <jack@suse.cz>, Petr Vorel <pvorel@suse.cz>
Subject: Re: [PATCH v2 1/3] lib: Add Bcachefs magic
Date: Fri, 12 Jan 2024 21:18:18 +0800
In-reply-to: <20231207194011.273027-2-pvorel@suse.cz>
Message-ID: <frz27k44.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org


On Thu 07 Dec 2023 at 20:40, Petr Vorel <pvorel@suse.cz> wrote:

> Signed-off-by: Petr Vorel <pvorel@suse.cz>
> ---
> New in v2
>
>  include/tst_fs.h  | 3 +++
>  lib/tst_fs_type.c | 2 ++
>  2 files changed, 5 insertions(+)
>
> diff --git a/include/tst_fs.h b/include/tst_fs.h
> index eb9841165..06f5be896 100644
> --- a/include/tst_fs.h
> +++ b/include/tst_fs.h
> @@ -34,6 +34,9 @@
>  #define TST_VFAT_MAGIC     0x4d44 /* AKA MSDOS */
>  #define TST_EXFAT_MAGIC    0x2011BAB0UL
>
> +/* fs/bcachefs/bcachefs_format.h */
> +#define TST_BCACHE_MAGIC		0xca451a4e
> +
>
Not object to the patch. There are three MAGIC values in
bcachefs_format.h: BCACHE_MAGIC, BCHFS_MAGIC, 
BCACHEFS_STATFS_MAGIC.

IIUC, BCACHE_MAGIC is the older one in superblock, BCHFS_MAGIC is 
the
new one. BCACHEFS_STATFS_MAGIC is for statfs.
Kent,
Would you please export needed magic values to 
include/uapi/linux/magic.h?
Since you are the maintainer also I'm confused about variables to 
be named.

--
Su

>  enum tst_fill_access_pattern {
>  	TST_FILL_BLOCKS,
>  	TST_FILL_RANDOM
> diff --git a/lib/tst_fs_type.c b/lib/tst_fs_type.c
> index d9c9c0817..7f0d61a8e 100644
> --- a/lib/tst_fs_type.c
> +++ b/lib/tst_fs_type.c
> @@ -36,6 +36,8 @@ const char *tst_fs_type_name(long f_type)
>  		return "9p";
>  	case TST_RAMFS_MAGIC:
>  		return "ramfs";
> +	case TST_BCACHE_MAGIC:
> +		return "bcachefs";
>  	case TST_BTRFS_MAGIC:
>  		return "btrfs";
>  	case TST_XFS_MAGIC:
