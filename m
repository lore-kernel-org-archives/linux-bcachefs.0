Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=edpnet.be header.i=@edpnet.be header.b="h/v7eDrs"
Received: from relay-b03.edpnet.be (relay-b03.edpnet.be [212.71.1.220])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37492C0
	for <linux-bcachefs@vger.kernel.org>; Sat, 18 Nov 2023 23:20:59 -0800 (PST)
X-ASG-Debug-ID: 1700378457-24639c7fb9505bb0001-qsCQDO
Received: from LXmail03.edpnet.net (lxmail03.edpnet.net [212.71.0.137]) by relay-b03.edpnet.be with ESMTP id 1r3MT6SApAsyukIl (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO); Sun, 19 Nov 2023 08:20:57 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@edpnet.be
X-Barracuda-Effective-Source-IP: lxmail03.edpnet.net[212.71.0.137]
X-Barracuda-Apparent-Source-IP: 212.71.0.137
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=edpnet.be; s=default;
	t=1700378457; bh=ar2rhBpvFd8ky2i9avlsSnmQ8iq0gac+X6ilEihrFEA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=h/v7eDrscUqai6YsLG2de7JlcFi0nAXK8mK+CRWBPYw/1MVeHJWr7MKThQXsPftLp
	 bJwjPR+wCmDQxFbry1gvHbq7hLo3zCu3oyAH4O7wRDmtSswHXRoj+Kf/ocE1JigvpH
	 C7Mxi9+hsAEF0GQM9UU+3+bzYqRNDG+gqYMO5e1k=
Received: from webmail.edpnet.be (unknown [212.71.0.141])
	(Authenticated sender: janpietersol1.m1@edpnet.org)
	by LXmail03.edpnet.net (Postfix) with ESMTPA id 4SY29h6ZVhz10Zk;
	Sun, 19 Nov 2023 08:20:56 +0100 (CET)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sun, 19 Nov 2023 08:20:55 +0100
From: janpieter.sollie@edpnet.be
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Janpieter Sollie
 <janpieter.sollie@kabelmail.de>
Subject: Re: [PATCH v4 02/10] Run bcachefs tests on emulated architectures
In-Reply-To: <20231118200921.fdimf2qysk7kphqk@moria.home.lan>
X-ASG-Orig-Subj: Re: [PATCH v4 02/10] Run bcachefs tests on emulated architectures
References: <20231118194453.41324-1-janpieter.sollie@kabelmail.de>
 <20231118194453.41324-3-janpieter.sollie@kabelmail.de>
 <20231118200921.fdimf2qysk7kphqk@moria.home.lan>
User-Agent: edpnet Webmail/1.6.3
Message-ID: <40dbf3f38c9305dc079e76aeb8f11de3@edpnet.be>
X-Sender: janpieter.sollie@edpnet.be
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: lxmail03.edpnet.net[212.71.0.137]
X-Barracuda-Start-Time: 1700378457
X-Barracuda-Encrypted: TLS_AES_256_GCM_SHA384
X-Barracuda-URL: https://212.71.1.220:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 1357
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=NO_REAL_NAME
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.116953
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 NO_REAL_NAME           From: does not include a real name

On 2023-11-18 21:09, Kent Overstreet wrote:

>> diff --git a/root_image b/root_image
>> index 26c99fe..a881714 100755
>> --- a/root_image
>> +++ b/root_image
>> @@ -118,7 +118,12 @@ PACKAGES+=(cryptsetup)
>> PACKAGES+=(multipath-tools sg3-utils srptools)
>> 
>> # ZFS support
>> -PACKAGES+=("linux-headers-generic" dkms zfsutils-linux zfs-dkms)
>> +PACKAGES+=("linux-headers-generic")
>> +# unless no other option when cross-compiling, ignore ZFS
>> +# DKMS needs to cross-compile the module,
>> +# against a different kernel on a different CPUarchitecture.
>> +# this has to cause errors
>> +[[ -n $CROSS_COMPILE ] && PACKAGES+=(dkms zfsutils-linux zfs-dkms)
>> 
>> # suspend testing:
>> # [[ $KERNEL_ARCH = x86 ]] && PACKAGES+=(uswsusp)
>> @@ -302,6 +307,7 @@ cmd_create()
>> --components='main,contrib,non-free,bullseye-backports' \
>> bullseye "$MNT" "$MIRROR"
>> 
>> +    [[ -n ${CROSS_COMPILE} ]] || cp $(which qemu-${ktest_arch}) 
>> ${MNT}$(which qemu-${ktest_arch})
> 
> What? Please explain.

If using a cross-compile feature, you need the qemu static helper to be 
on the target,
otherwise you can't run your binaries compiled for another cpu.
when entering the chroot, this is a requirement for running another ABI.
I leave it there because you'll need it again when performing root_image 
update

Janpieter
