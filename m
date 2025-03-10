Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFF422CBD7;
	Mon, 10 Mar 2025 14:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741617368; cv=none; b=eqhbQQeymY1cecywM//7jaHXP5y0RJv/ZmHSt6uMiVTL8i8XqjlN6on3xhQocrgXAlX9OphadzDyI/QVCdEF8xCcOoWqEXcrR3kt4l17dNqHyYez/C0o7wQTS0SAaoijiehGw3KMfq3iUBWPNaEF0zC90qVOF62WTqAjIyNdIsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741617368; c=relaxed/simple;
	bh=arOQ0i7ZBsGLe2KAwbnZ6v1cFtJ9JyDFbTw2aeLnQD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QK1insIyQ9Z8KsbpiDB/df57om3yrC+efYyXk3G9FE/1yv3YDuSD/4e2cdD59mH+BqSOxf3dt4LwwoEfqQpieOF33O+Ta9byextCF1M59cC9wmx5RFN6qDrdGGNbcSgJJUbpsHmI71WcZIMa3FvJSc4DL1l/9EhUt5Mcnrf8T1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NRooxttU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NRooxttU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA16C4CEEB;
	Mon, 10 Mar 2025 14:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741617367;
	bh=arOQ0i7ZBsGLe2KAwbnZ6v1cFtJ9JyDFbTw2aeLnQD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NRooxttUlNdOtDI7XGvYqu6/hX8i4jWEt8FYaHEyR7bevMpu0ry0yiWDXaQmwRpT9
	 YaN+vVQDGOsa3RPn+0o2qfQ5N/PZ9MxHBFL7KPlYHZRBSHGBtEd+IqqmndEoDPJbLn
	 ebK0nlRnJ6YNxajvRql0zGIyWoYv0GQfEr76CaOE=
Date: Mon, 10 Mar 2025 15:36:04 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: cve@kernel.org, =?iso-8859-1?Q?G=FCnther?= Noack <gnoack@google.com>,
	linux-security-module@vger.kernel.org,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Dave Chinner <david@fromorbit.com>, linux-bcachefs@vger.kernel.org
Subject: Re: CVE-2025-21830: landlock: Handle weird files
Message-ID: <2025031034-savanna-debit-eb8e@gregkh>
References: <2025030611-CVE-2025-21830-da64@gregkh>
 <20250310.ooshu9Cha2oo@digikod.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250310.ooshu9Cha2oo@digikod.net>

On Mon, Mar 10, 2025 at 01:00:50PM +0100, Mickaël Salaün wrote:
> Hi Greg,
> 
> FYI, I don't think this patch fixes a security issue.  If attackers can
> corrupt a filesystem, then they should already be able to harm the whole
> system.
> 
> The commit description might be a bit confusing, but from an access
> control point of view, the filesystem on which we spotted this issue
> (bcachefs) does not allow to open weird files (but they are still
> visible, hence this patch) and I guess it would be the same for other
> filesystems, right?  I'm not sure how a weird file could be used by user
> space.  See
> https://lore.kernel.org/all/Zpc46HEacI%2Fwd7Rg@dread.disaster.area/
> 
> The goal of this fix was mainly to not warn about a bcachefs issue (and
> avoid related syzkaller report for Landlock), and to harden Landlock in
> case other filesystems have this kind of bug.

It was issue a CVE because the reviewers thought that it was a way to
circumvent the landlock permission checks, based on the changelog text
(note, creating a "corrupted filesystem" is quite easy to get many Linux
systems to auto-mount it, so those types of issues do get assigned
CVEs.)

If you all do not think this meets the definition of a vulnerability as
defined by CVE.org as:
	An instance of one or more weaknesses in a Product that can be
	exploited, causing a negative impact to confidentiality, integrity, or
	availability; a set of conditions or behaviors that allows the
	violation of an explicit or implicit security policy.

We will be glad to revoke it, just let us know.

thanks,

greg k-h
