Received: from mail-108-mta176.mxroute.com (mail-108-mta176.mxroute.com [136.175.108.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345EC628
	for <linux-bcachefs@vger.kernel.org>; Mon, 15 Jan 2024 00:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e.netreq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e.netreq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=e.netreq.com header.i=@e.netreq.com header.b="SjvScM4W"
Received: from filter006.mxroute.com ([136.175.111.2] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta176.mxroute.com (ZoneMTA) with ESMTPSA id 18d0a667f990003727.001
 for <linux-bcachefs@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Sun, 14 Jan 2024 23:55:06 +0000
X-Zone-Loop: 6ed42bd8d733214c40e45fad5c9f9ad07cc58e22a0b6
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=e.netreq.com; s=x; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:
	Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=t5gMVjSZ5W8PB8ZjeGVq50v1c9apc/Awfncr1jCZ6TM=; b=SjvScM4WGpKafqW/7BZtpB2M+b
	rUThNLHmdIKBeW5g0yY0sEMex4yM8/pxAYVAGaZo2mdCUsXd8JEp5rzbek/pRZhEjL2tm2TI7CJa3
	9yz6bj+fuuAsB8u8E8zKaJmyRpLUSu/T1muOWWT0SAlJ6grzgFnJjrZYFGIO0n82ksM7gY3AyS/2M
	YVO5z3YTOhFTTb0qCLrMB4uxINv6BCxIdYlgEZPFX60Da+Yg4cI77pohAdAzkre3107sQPbf+BB3z
	cl0b/m/L8wk/v64DdLIWG965S0Pw6A/6/apSnnzpBiJ0jlQiTQeHaXNTfeDC7gF3DlB8BTEModFZY
	D7PWpkaA==;
Date: Sun, 14 Jan 2024 18:55:03 -0500
From: Alec Moskvin <list.bcachefs@e.netreq.com>
To: linux-bcachefs@vger.kernel.org
Subject: fsck: bch2_parse_mount_opts() Bad mount option read_only
Message-ID: <20240114235503.GA269705@emmetten>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Authenticated-Id: alec@netreq.com

On Linux 6.7.0 with the latest bcachefs-tools 1.4.0, I get an error when 
trying to run fsck:

    bcachefs fsck -v /dev/sda3
    bch2_parse_mount_opts() Bad mount option read_only

If I try a newer git revision of bcachefs-tools, it works but does an 
upgrade of the fs version:

    bcachefs fsck /dev/sda3
    mounting version 1.3: rebalance_work opts=ro,compression=zstd:15,degraded,verbose,fsck,fix_errors=ask,read_only
    recovering from clean shutdown, journal seq 116268
    Doing compatible version upgrade from 1.3: rebalance_work to 1.4: member_seq 

and then when I mount it, it downgrades:

    [Jan14 11:06] bcachefs (sda3): mounting version 1.4: (unknown version) opts=compression=zstd:15
    [  +0.000016] bcachefs (sda3): recovering from clean shutdown, journal seq 116272
    [  +0.000003] bcachefs (sda3): Version downgrade required:
    
    [  +0.200171] bcachefs (sda3): alloc_read... done

Is there a correspondence between the kernel and bcachefs-tools 
versions? I.e., should bcachefs-tools 1.3.6 be used until a kernel with 
bcachefs 1.4 is released?

Thanks,
Alec
