import React from "react";
import Link from 'next/link'
import { signIn, signOut, useSession } from "next-auth/client";

export default function Shell(props) {
	const [session] = useSession();

	return (
		<div>
			<div className="border-b px-4 py-2 text-xs">
				<div className="flex space-x-3">
					<div>matteing.com/devkit</div>
					<div className="flex-1"></div>
					{session ? (
						<div className="text-gray-500">
							<div className="font-semibold">
								{session.user.email}
							</div>
						</div>
					) : (
						<a
							className="text-gray-500 cursor-pointer"
							onClick={signIn}
						>
							Login
						</a>
					)}
					<Link href="/admin"><div className="text-gray-500">Admin</div></Link>
				</div>
			</div>
			{props.children}
		</div>
	);
}
