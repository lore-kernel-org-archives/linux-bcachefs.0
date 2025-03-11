Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD455258
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Mar 2025 02:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741658983; cv=none; b=tJfT6Y7u/SnlwGIZuWAD7Aa5QvHJbQ9YaVOJhbjfQNL6xqPXdVL7ClBEMTfcTGpIzoBRl+KPLqe5mPD8mqTVQcAY1B//qUanBX7a36XYQXqg/Svwmwc9jP1fvcbooj7TfZgiYAuebWfXEcwT8VJkb0WJ88Cmi4wuO/dmf4Txn48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741658983; c=relaxed/simple;
	bh=vc/6rGFLTQ02wSDhs9ufd1r9GKxM1FLi6/yiBbJFpgs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NiSqJ8PW32Il0oMsgY3HoGSvI3LofJulQgTxswYg6pJkCGo3PLLxWx7Nslb33M7CHg0rNTpw7WIXyuckHdjTytyzSZjuCTfjngY2EsxDfQqrcAZbPqIyIhRcsdh8tu31Ar6SlmTi0iQDCF1jzA7XQc8KcviLV2Rmt9YrihYl8Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FwGJl+hM; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FwGJl+hM"
Date: Mon, 10 Mar 2025 22:09:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741658969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FOtwyQiRQuzAjOzXimG6a4ZWVrTf10aj6g/DiKiVtV4=;
	b=FwGJl+hMtWoZvI39VWOngg5XF9zCzR0WOO9A6lXMljUW29zOvOuVicb9JBrhnVgE/Vfbuq
	SlGOfTVKP3gqjOoD+t/nyQC1J+d0phaZjmId07mdEuBczaSG0JNkSZ5VOCKooHwXy0DIXZ
	9W09lLw3kEIFh0W/8H+ZdHQwg4eURQo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dave Chinner <david@fromorbit.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, cve@kernel.org, 
	=?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>, linux-security-module@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: CVE-2025-21830: landlock: Handle weird files
Message-ID: <33m2msv3elqbviurca3ayebwzfzzjenh472b246gf7hbkfjk25@sl7plpwvpxig>
References: <2025030611-CVE-2025-21830-da64@gregkh>
 <20250310.ooshu9Cha2oo@digikod.net>
 <2025031034-savanna-debit-eb8e@gregkh>
 <Z8948cR5aka4Cc5g@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z8948cR5aka4Cc5g@dread.disaster.area>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 11, 2025 at 10:42:41AM +1100, Dave Chinner wrote:
> [cc linux-fsdevel]
> 
> On Mon, Mar 10, 2025 at 03:36:04PM +0100, Greg Kroah-Hartman wrote:
> > On Mon, Mar 10, 2025 at 01:00:50PM +0100, Mickaël Salaün wrote:
> > > Hi Greg,
> > > 
> > > FYI, I don't think this patch fixes a security issue.  If attackers can
> > > corrupt a filesystem, then they should already be able to harm the whole
> > > system.
> > > 
> > > The commit description might be a bit confusing, but from an access
> > > control point of view, the filesystem on which we spotted this issue
> > > (bcachefs) does not allow to open weird files (but they are still
> > > visible, hence this patch) and I guess it would be the same for other
> > > filesystems, right?  I'm not sure how a weird file could be used by user
> > > space.  See
> > > https://lore.kernel.org/all/Zpc46HEacI%2Fwd7Rg@dread.disaster.area/
> > > 
> > > The goal of this fix was mainly to not warn about a bcachefs issue (and
> > > avoid related syzkaller report for Landlock), and to harden Landlock in
> > > case other filesystems have this kind of bug.
> > 
> > It was issue a CVE because the reviewers thought that it was a way to
> > circumvent the landlock permission checks, based on the changelog text
> > (note, creating a "corrupted filesystem" is quite easy to get many Linux
> > systems to auto-mount it, so those types of issues do get assigned
> > CVEs.)
> 
> That's an argument straight from the security theatre.
> 
> > If you all do not think this meets the definition of a vulnerability as
> > defined by CVE.org as:
> > 	An instance of one or more weaknesses in a Product that can be
> > 	exploited, causing a negative impact to confidentiality, integrity, or
> > 	availability; a set of conditions or behaviors that allows the
> > 	violation of an explicit or implicit security policy.
> 
> Yes, so shall we follow this reasoning based on untrusted user
> auto-mounts of untrusted devices to it's logical conclusion?
> 
> If an untrusted user is in control of the filesystem image, then
> they don't need to corrupt the filesystem image to subvert the
> system. They can just change the permissions on files, change ACLs,
> change security xattrs (selinux, landlock, smack, etc),
> replace the contents of file data (e.g. trojan executables), etc.

If user mounts are enabled, that comes with UID mapping, and device
nodes disabled - no?

Out of curiosity, what's keeping us from saying "user mounts are
generally expected to be safe" for XFS?

Obviously, that does expose a massive attack surface, so saying that for
a C codebase that wasn't initially designed for it has a high pucker
factor.

But I've been impressed with syzbot's ability to find bugs, so barring
architectural issues which I assume you'd know about it seems it's not
nearly as crazy a thought as it used to be - for XFS, as you guys have
been the most rigorous about hardening so I expect that's about as good
as it's going to get until we start rewriting our filesystems in Rust.
