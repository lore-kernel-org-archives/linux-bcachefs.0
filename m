Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893A5839F4
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Mar 2025 21:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741470833; cv=none; b=kkMp6ryUIdEK+9OBXQXBrxNqf2UWCzzgPC8tFvPLQSfUkXpWPdsB+K7IhlSUVldPMaOuUi8xSlXkjn7gmVdGOVx5PvOREF0aDn8nYJnZNUh7PUlGYWL/HoWj0t6fRh2WQetYMuqqIxIV3oTvmUzyI+R6qEpysLisZ9LfXt52EuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741470833; c=relaxed/simple;
	bh=CYnmF9Do29+aMPutGws7tNyvaQUYvmcRni7TXMbB5dI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QE60B5WrAEU+eQVGnnqX1KVCjbZL+iVzAH8E4Ka9S2t385O1w97h1i4xfDLHwvNhJYbzF+6JmRPwyQogxz4Q15vpM9URwFph7yBRLpaQEjflAZc2fzmHZub/Jr27e/ndMCvG3wcH6tpQExmI5z0nz4LSdbcE74utSauRhWjol2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from trampoline.thunk.org (pool-173-48-112-49.bstnma.fios.verizon.net [173.48.112.49])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 528Lr6iT010003
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 8 Mar 2025 16:53:06 -0500
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id EE5512E010B; Sat, 08 Mar 2025 16:53:05 -0500 (EST)
Date: Sat, 8 Mar 2025 16:53:05 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Hector Martin <marcan@marcan.st>,
        syzbot <syzbot+4364ec1693041cad20de@syzkaller.appspotmail.com>,
        broonie@kernel.org, joel.granados@kernel.org, kees@kernel.org,
        linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] general protection fault in proc_sys_compare
Message-ID: <20250308215305.GB69932@mit.edu>
References: <67ca5dd0.050a0220.15b4b9.0076.GAE@google.com>
 <239cbc8a-9886-4ebc-865c-762bb807276c@marcan.st>
 <ph6whomevsnlsndjuewjxaxi6ngezbnlmv2hmutlygrdu37k3w@k57yfx76ptih>
 <20250307133126.GA8837@mit.edu>
 <a5avbx7c6pilz4bnp3iv7ivuxtth7udo6ypepemhumsxvuawrw@qa7kec5sxyhp>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5avbx7c6pilz4bnp3iv7ivuxtth7udo6ypepemhumsxvuawrw@qa7kec5sxyhp>

On Fri, Mar 07, 2025 at 09:33:11AM -0500, Kent Overstreet wrote:
>
> > Maybe this is something Syzbot could implement?
> 
> Wouldn't it be better to have it in 'git bisect'?

"Git bisect" is the wrong layer of abstraction.  It doesn't know
anything about (a) how build the software package (which might not be
the kernel, remember), nor how to run a test, nor how to tell whether
a test run was successful or a failure.

It's expected that those tools need to be built on top of "git
bisect."  For example Steve Rostedt has contributed ktest.pl, which is
in the kernel sources in tools/teseting/ktest/.  This assumes that the
system under test is a bare metal machine where is accessible via
ssh/scp, and that builds are done on the local machine where ktest.pl
is run.

ktest.pl is not something I've used myself, since I do pretty much all
of my testing using VM's, and in the case of gce-xfstests, we spin up
a fast compile VM which does the kernel compilation and uploads the
freshly compiled kernel to Google Cloud Storage (GCS), and then kicks
off one or more test VM's which fetches the kernel from GCS, with the
command of which tests to run encoded in the test VM metadata.  I also
have a monitoring VM that detects if a test VM hangs, so it can
automatically restart the test VM.  All of this is logic which is't
supported by ktest.pl, and obviously *far* beyond the scope of "git
bisect".

And while Syzbot can use Google Cloud in addition to qemu, its
infrastruture for how it compiles kernels and runs its test VM's is
sufficiently different that it's not clear that software written for
one infrastructure would be easily applicable to another.

> If only we had interns and grad students for this sort of thing :)

The lightweight test manager (ltm) for gce-xfstests was implemented by
an intern.  And the kernel compilation service (kcs), git branch
watcher, and git bisection engine for gce-xfstests was done by a group
of undergraduates at a unversity in Boston as part of a software
engineering class project.

Mentoring interns and undergraduates was incredibly fulfilling, and I
very much enjoyed the experience.  I'd like to think I helped them to
become better software engineers.  However, mentoring students takes a
significant amount of time, and on net, it's not clear it was a win
from a personal time ROI perspective.

We did manage to recruit the intern to become a SWE at Google after he
graduated, so that was definitely considered a win from my company's
perspective.  :-)

						- Ted
