Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A170830E826
	for <linux-bcachefs@vger.kernel.org>; Fri, 20 Jun 2025 12:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750423481; cv=none; b=VUzT9v3/J58cFrcRhQdcr8BoJB2xy6qIhej3aM4MhETY88iqZ+fYpEfM9LGaMmUvBcg+dAWDwSVrQUKhVFHHTs9cd8PSumuwssnfJ6qpgkadRc1vhI4dFmRKDk2ms43UDsif2ERnRpkdyHsuANlo6iBdj4kWI1UmjXbrEUwsJLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750423481; c=relaxed/simple;
	bh=kT8qwNLgErIqGwBdFDitsulHRfVxvJjvNWCUlLlMzn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t07hPyWcu1x/a9l/dSY1T/R+VnmhtuOtemnvSO7RpfD1iPfveH/LL+1zNtgRmdHAN+kfhuKbo0yWVoO4PYM+6FOAeOCjJzHZoh/2Hp7dZhXZVFYY/RLUor1MQXEBx1G9phNTkhkl8PyXm9d5oGAztLI6fr4MsLwwdG86NpHpcRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from trampoline.thunk.org (pool-173-48-82-219.bstnma.fios.verizon.net [173.48.82.219])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 55KChkf1014510
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Jun 2025 08:44:00 -0400
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 2AEA42E0011; Fri, 20 Jun 2025 08:43:46 -0400 (EDT)
Date: Fri, 20 Jun 2025 08:43:46 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Martin Steigerwald <martin@lichtvoll.de>,
        Jani Partanen <jiipee@sotapeli.fi>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.16-rc3
Message-ID: <20250620124346.GB3571269@mit.edu>
References: <4xkggoquxqprvphz2hwnir7nnuygeybf2xzpr5a4qtj4cko6fk@dlrov4usdlzm>
 <06f75836-8276-428e-b128-8adffd0664ee@sotapeli.fi>
 <ep4g2kphzkxp3gtx6rz5ncbbnmxzkp6jsg6mvfarr5unp5f47h@dmo32t3edh2c>
 <3366564.44csPzL39Z@lichtvoll.de>
 <hewwxyayvr33fcu5nzq4c2zqbyhcvg5ryev42cayh2gukvdiqj@vi36wbwxzhtr>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hewwxyayvr33fcu5nzq4c2zqbyhcvg5ryev42cayh2gukvdiqj@vi36wbwxzhtr>

On Fri, Jun 20, 2025 at 04:14:24AM -0400, Kent Overstreet wrote:
> 
> There is a time and a place for rules, and there is a time and a place
> for using your head and exercising some common sense and judgement.
> 
> I'm the one who's responsible for making sure that bcachefs users have a
> working filesystem. That means reading and responding to every bug
> report and keeping track of what's working and what's not in
> fs/bcachefs/. Not you, and not Linus.

Kent, the risk as always of adding features after the merge window is
that you might introduce regressions.  This is especially true if you
are making changes to relatively sensitive portions of any file system
--- such as journalling.

The rules around the merge window is something which the vast majority
of the kernel developers have agreeded upon for well over a decade.
And it is Linus's responsibility to *enforce* those rules.

If, as you say, bcachefs is experimental, and no sane person should be
trusting their data on it, then perhaps this shouldn't be urgent.  On
the flip side, perhaps if you are claiming that people should be using
it for critical data, then perhaps your care for user's data safety
should be.... revisted.

Cheers,

						- Ted
