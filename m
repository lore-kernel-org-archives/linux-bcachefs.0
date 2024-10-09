Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9C152F9E
	for <linux-bcachefs@vger.kernel.org>; Wed,  9 Oct 2024 03:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728445923; cv=none; b=s4xZeGA00iwqi+KW0lQnFWjuSuCT1L1/EDzeU6cvzeojgkpA0yHP3r/3KAZn8gyw1Xthz78kx6llJ69dSrEVSmHKdtLaRAZ0M10LXS/jiBSVgUDXTde3VdbMe0/Axalnyzsi0H1gVdvLdGyhaw7vDfRJezqBuD5I1RSqcOvoySs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728445923; c=relaxed/simple;
	bh=CNA+IwsxiyK9OFBTXdJn56em+2sA6DE+qY0MP6jbhd8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X7E9QQ2lNERQh0P+aszVa/Hw+34RgfStEIJh52X6YzW6c18jkqDqqTRhRjo+lfWr35D6ey3dy87cHMQIhJaywCYoedESPxBBxgC05oqRPt2f4BjAWbIE3zbTXySwNcBKxAaqQcHIeDL25R1WIYKmcY0WQX3FiwtdctlDx0k7VTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Vq14Ska6; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Vq14Ska6"
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 4993pdiQ026190
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 8 Oct 2024 23:51:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1728445902; bh=hc/4UiI2kJNBSUQuicW9YL2kaR4Xf/C8fzRhntjE+WM=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=Vq14Ska6VHQMslm1coPtYYuQspE169G6Sv6tSkuYceol5m48jXCBzfJMjOpG8ukEa
	 SpqdiLM5DuTk2Iaqavt89b0Fog08Zg821cepbtRRrSXQ4KnJklrcBsvmE206Uvtby5
	 aShbbik+HF4lqbrOSb7KQ2e0DAfSXfVYcW2E4L0O4jDixO17pTC08yvBL3eTB51vxJ
	 l2SUQ4nqdNr6PG6vEAR+X23LcMNAxxFGcGbTqspMjYekKoeeRJamQKJl5nYo/gMWgw
	 KB7aYHk1vgPSyBzC8O+VTv15fz6h9xMLDv+7Af1KjjfUrP2/0qol6yOpM0XPQCyhUz
	 R42RibVDZ+nbw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 92359340572; Tue, 08 Oct 2024 22:51:39 -0500 (CDT)
Date: Tue, 8 Oct 2024 22:51:39 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.12-rc2
Message-ID: <20241009035139.GB167360@mit.edu>
References: <cphtxla2se4gavql3re5xju7mqxld4rp6q4wbqephb6by5ibfa@5myddcaxerpb>
 <CAHk-=wjit-1ETRxCBrQAw49AUcE5scEM5O++M=793bDWnQktmw@mail.gmail.com>
 <x7w7lr3yniqrgcuy7vzor5busql2cglirhput67pjk6gtxtbfc@ghb46xdnjvgw>
 <CAHk-=wi-nKcOEnvX3RX+ovpsC4GvsHz1f6iZ5ZeD-34wiWvPgA@mail.gmail.com>
 <e3qmolajxidrxkuizuheumydigvzi7qwplggpd2mm2cxwxxzvr@5nkt3ylphmtl>
 <CAHk-=wjns3i5bm++338SrfJhrDUt6wyzvUPMLrEvMZan5ezmxQ@mail.gmail.com>
 <2nyd5xfm765iklvzjxvn2nx3onhtdntqrnmvlg2panhtdbff7i@evgk5ecmkuoo>
 <20241006043002.GE158527@mit.edu>
 <jhvwp3wgm6avhzspf7l7nldkiy5lcdzne5lekpvxugbb5orcci@mkvn5n7z2qlr>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jhvwp3wgm6avhzspf7l7nldkiy5lcdzne5lekpvxugbb5orcci@mkvn5n7z2qlr>

On Sun, Oct 06, 2024 at 12:33:51AM -0400, Kent Overstreet wrote:
> 
> Correct me if I'm wrong, but your system isn't available to the
> community, and I haven't seen a CI or dashboard for kdevops?

It's up on github for anyone to download, and I've provided pre-built
test appliance so people don't have to have downloaded xfstests and
all of its dependencies and build it from scratch.  (That's been
automated, of course, but the build infrastructure is setup to use a
Debian build chroot, and with the precompiled test appliances, you can
use my test runner on pretty much any Linux distribution; it will even
work on MacOS if you have qemu built from macports, although for now
you have to build the kernel on Linux distro using Parallels VM[1].)

I'll note that IMHO making testing resources available to the
community isn't really the bottleneck.  Using cloud resources,
especially if you spin up the VM's only when you need to run the
tests, and shut them down once the test is complete, which
gce-xfstests does, is actually quite cheap.  At retail prices, running
a dozen ext4 file system configurations against xfstests's "auto"
group will take about 24 hours of VM time, and including the cost of
the block devices, costs just under two dollars USD.  Because the
tests are run in parallel, the total wall clock time to run all of the
tests is about two and a half hours.  Running the "quick" group on a
single file system configuration costs pennies.  So the $300 of free
GCE credits will actually get someone pretty far!

No, the bottleneck is having someone knowledgeable enough to interpret
the test results and then finding the root cause of the failures.
This is one of the reasons why I haven't stressed all that much about
dashboards.  Dashboards are only useful if the right person(s) is
looking at them.  That's why I've been much more interested in making
it stupidly easy to run tests on someone's local resources, e.g.:

     https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-quickstart.md

In fact, for most people, the entry point that I envision as being
most interesting is that they download the kvm-xfstests, and following
the instructions in the quickstart, so they can run "kvm-xfstests
smoke" before sending me an ext4 patch.  Running the smoke test only
takes 15 minutes using qemu, and it's much more convenient for them to
run that on their local machine than to trigger the test on some
remote machine, whether it's in the cloud or someone's remote test
server.

In any case, that's why I haven't been interesting in working with
your test infrastructure; I have my own, and in my opinion, my
approach is the better one to make available to the community, and so
when I have time to improve it, I'd much rather work on
{kvm,gce,android}-xfstests.

Cheers,

						- Ted


[1] Figuring out how to coerce the MacOS toolchain to build the Linux
kernel would be cool if anyone ever figures it out.  However, I *have*
done kernel development using a Macbook Air M2 while on a cruise ship
with limited internet access, building the kernel using a Parallels VM
running Debian testing, and then using qemu from MacPorts to avoid the
double virtualization performance penalty to run xfstests to test the
freshly-built arm64 kernel, using my xfstests runner -- and all of
this is available on github for anyone to use.
