Received: from smtp-8fa9.mail.infomaniak.ch (smtp-8fa9.mail.infomaniak.ch [83.166.143.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B18A22A81A
	for <linux-bcachefs@vger.kernel.org>; Mon, 10 Mar 2025 12:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741608066; cv=none; b=bpNxNVyLAUK3dgKevblivBozpFx7chaL14PDWuP2Zs2qAjNrRunGQCWF3U9x4EnkCAmUzbX1NriRMbeyA2MzAHQ6c6sSahFlPg7TVPK/tKwv1t9VFZDyKg0lhnMLaeWqRqHcpdERoxgnyiksaoWt7gwrPrTArFAV6jXOKE0SqtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741608066; c=relaxed/simple;
	bh=5to7xJ4RvK1ErywFRZV2ft01RdlvEKbvsFSZz75BXgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R0BDQKZOQD7cIXCWSzNmUK2dA2EN1ZFo2vdnFv14l70pt9OjVZgQ529RtAjqSkam9n8h0wo6ckIBCnVcLaSw/hUy2MMch2szbbGZ/WH7YbZo5kPrxw44NEBL1G7Zf9q3BjHOEBYZqqN+8V1DBoUrY16FTatm7mTVRvH47FPqUlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=Unn8M+HJ; arc=none smtp.client-ip=83.166.143.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="Unn8M+HJ"
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4ZBFpX51b2zxG5;
	Mon, 10 Mar 2025 13:00:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1741608052;
	bh=zxZzhG+vZe9nrM+OlOIs19dFolMtjMMIUGdmnFWrTJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Unn8M+HJn0G8q4T6Ajkcv3VxD3F0I4uYFYLv7CnHTeOEr3QOkfgMdmgsfdbTca/Jl
	 Fptc+MEKDZBmKlk2Nh8WRPQf+9NQ+1sDJ+bOInovL2Jcj4nGGmQR4FKroposmzxT6m
	 RTyTosdpW0vLrffdTk21eiuirW52IgZfwYDQjCdw=
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4ZBFpX0FYjzRJ;
	Mon, 10 Mar 2025 13:00:51 +0100 (CET)
Date: Mon, 10 Mar 2025 13:00:50 +0100
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: cve@kernel.org, =?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>, 
	linux-security-module@vger.kernel.org, Kent Overstreet <kent.overstreet@linux.dev>, 
	Dave Chinner <david@fromorbit.com>, linux-bcachefs@vger.kernel.org
Subject: Re: CVE-2025-21830: landlock: Handle weird files
Message-ID: <20250310.ooshu9Cha2oo@digikod.net>
References: <2025030611-CVE-2025-21830-da64@gregkh>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2025030611-CVE-2025-21830-da64@gregkh>
X-Infomaniak-Routing: alpha

Hi Greg,

FYI, I don't think this patch fixes a security issue.  If attackers can
corrupt a filesystem, then they should already be able to harm the whole
system.

The commit description might be a bit confusing, but from an access
control point of view, the filesystem on which we spotted this issue
(bcachefs) does not allow to open weird files (but they are still
visible, hence this patch) and I guess it would be the same for other
filesystems, right?  I'm not sure how a weird file could be used by user
space.  See
https://lore.kernel.org/all/Zpc46HEacI%2Fwd7Rg@dread.disaster.area/

The goal of this fix was mainly to not warn about a bcachefs issue (and
avoid related syzkaller report for Landlock), and to harden Landlock in
case other filesystems have this kind of bug.

Anyway, always good to backport such fix.

Regards,
 Mickaël

On Thu, Mar 06, 2025 at 05:08:13PM +0100, Greg Kroah-Hartman wrote:
> Description
> ===========
> 
> In the Linux kernel, the following vulnerability has been resolved:
> 
> landlock: Handle weird files
> 
> A corrupted filesystem (e.g. bcachefs) might return weird files.
> Instead of throwing a warning and allowing access to such file, treat
> them as regular files.
> 
> The Linux kernel CVE team has assigned CVE-2025-21830 to this issue.
> 
> 
> Affected and fixed versions
> ===========================
> 
> 	Issue introduced in 5.13 with commit cb2c7d1a1776057c9a1f48ed1250d85e94d4850d and fixed in 6.1.129 with commit 7d6121228959ddf44a4b9b6a177384ac7854e2f9
> 	Issue introduced in 5.13 with commit cb2c7d1a1776057c9a1f48ed1250d85e94d4850d and fixed in 6.6.76 with commit 39bb3d56f1c351e76bb18895d0e73796e653d5c1
> 	Issue introduced in 5.13 with commit cb2c7d1a1776057c9a1f48ed1250d85e94d4850d and fixed in 6.12.13 with commit 2569e65d2eb6ac1afe6cb6dfae476afee8b6771a
> 	Issue introduced in 5.13 with commit cb2c7d1a1776057c9a1f48ed1250d85e94d4850d and fixed in 6.13.2 with commit 0fde195a373ab1267e60baa9e1a703a97e7464cd
> 	Issue introduced in 5.13 with commit cb2c7d1a1776057c9a1f48ed1250d85e94d4850d and fixed in 6.14-rc1 with commit 49440290a0935f428a1e43a5ac8dc275a647ff80
> 
> Please see https://www.kernel.org for a full list of currently supported
> kernel versions by the kernel community.
> 
> Unaffected versions might change over time as fixes are backported to
> older supported kernel versions.  The official CVE entry at
> 	https://cve.org/CVERecord/?id=CVE-2025-21830
> will be updated if fixes are backported, please check that for the most
> up to date information about this issue.
> 
> 
> Affected files
> ==============
> 
> The file(s) affected by this issue are:
> 	security/landlock/fs.c
> 
> 
> Mitigation
> ==========
> 
> The Linux kernel CVE team recommends that you update to the latest
> stable kernel version for this, and many other bugfixes.  Individual
> changes are never tested alone, but rather are part of a larger kernel
> release.  Cherry-picking individual commits is not recommended or
> supported by the Linux kernel community at all.  If however, updating to
> the latest release is impossible, the individual changes to resolve this
> issue can be found at these commits:
> 	https://git.kernel.org/stable/c/7d6121228959ddf44a4b9b6a177384ac7854e2f9
> 	https://git.kernel.org/stable/c/39bb3d56f1c351e76bb18895d0e73796e653d5c1
> 	https://git.kernel.org/stable/c/2569e65d2eb6ac1afe6cb6dfae476afee8b6771a
> 	https://git.kernel.org/stable/c/0fde195a373ab1267e60baa9e1a703a97e7464cd
> 	https://git.kernel.org/stable/c/49440290a0935f428a1e43a5ac8dc275a647ff80
