Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20AA23CE
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Mar 2025 13:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741354325; cv=none; b=WZ82Jk4r6CV5nMVWK2PAcojOoFnfesddqjeF4y2fPs9ALiM6RB4yvkNKl4n0dkCgBTVLroC4mz8yVtSOK5eI2wxBgxcL9a8FiGbnAMmodWS4aSusD6vSeqgrVbhnlkkPhIBYxVJ4o1XIKFEyCxPW5ZSgEOWKIVzTr/hjkSSb6Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741354325; c=relaxed/simple;
	bh=Rk3HTJSdGsZ/NrV0XqotfCYqlViFG6WGB56pcYsPR1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iHmCUpTHbiE6IEoX5LQSN4H2qCe9Q+hi9BI1hv1XQP5H7PTk3A3vnBft6xDKd2K5pMDEWvVesLGqwnuX7UxU84OfQiQLCzv7tpkP+S7YniMF6eZ8WaZJKVcCZ7+lCN3eY1O39MrN9dN5TiF2k/i7huPsJ1zhuCQHoehubAVav34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from trampoline.thunk.org (pool-173-48-112-49.bstnma.fios.verizon.net [173.48.112.49])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 527DVQBt029743
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 7 Mar 2025 08:31:27 -0500
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 8E4FE2E010B; Fri, 07 Mar 2025 08:31:26 -0500 (EST)
Date: Fri, 7 Mar 2025 08:31:26 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Hector Martin <marcan@marcan.st>,
        syzbot <syzbot+4364ec1693041cad20de@syzkaller.appspotmail.com>,
        broonie@kernel.org, joel.granados@kernel.org, kees@kernel.org,
        linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] general protection fault in proc_sys_compare
Message-ID: <20250307133126.GA8837@mit.edu>
References: <67ca5dd0.050a0220.15b4b9.0076.GAE@google.com>
 <239cbc8a-9886-4ebc-865c-762bb807276c@marcan.st>
 <ph6whomevsnlsndjuewjxaxi6ngezbnlmv2hmutlygrdu37k3w@k57yfx76ptih>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ph6whomevsnlsndjuewjxaxi6ngezbnlmv2hmutlygrdu37k3w@k57yfx76ptih>

On Fri, Mar 07, 2025 at 06:51:23AM -0500, Kent Overstreet wrote:
> 
> Better bisection algorithm? Standand bisect does really badly when fed
> noisy data, but it wouldn't be hard to fix that: after N successive
> passes or fails, which is unlikely because bisect tests are coinflips,
> backtrack and gather more data in the part of the commit history where
> you don't have much.

My general approach when handling some test failure is to try running
the reproducer 5-10 times on the original commit where the failure was
detected, to see if the reproducer is reliable.  Once it's been
established whether the failure reproduces 100% of the time, or some
fraction of the time, say 25% of the time, then we can estalbish how
times we should try running the reproducer before we can conclude the
that a particular commit is "good" --- and the first time we detect a
failure, we can declare the commit is "bad", even if it happens on the
2nd out of the 25 tries that we might need to run a test if it is
particularly flaky.

Maybe this is something Syzbot could implement?

And if someone is familiar with the Go language, patches to implement
this in gce-xfstests's ltm server would be great!  It's something I've
wanted to do, but I haven't gotten around to implementing it yet so it
can be fully automated.  Right now, ltm's git branch watcher reruns
any failing test 5 times, so I get an idea of whether a failure is
flaky or not.  I'll then manually run a potentially flaky test 30
times, and based on how reliable or flaky the test failure happens to
be, I then tell gce-xfstests to do a bisect running each test N times,
without having it stop once the test fails.  It wasts a bit of test
resources, but since it doesn't block my personal time (results land
in my inbox when the bisect completes), it hasn't risen to the top of
my todo list.

Cheers,

					- Ted
